import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
	// MARK: - IB Outlets
	@IBOutlet weak private var imageView: UIImageView!
	@IBOutlet weak private var textLabel: UILabel!
	@IBOutlet weak private var counterLabel: UILabel!
	@IBOutlet weak private var noButton: UIButton!
	@IBOutlet weak private var yesButton: UIButton!

	// MARK: - Properties
	private var imageBorderColor: UIColor = .clear {
		didSet {
			imageView.layer.borderColor = imageBorderColor.cgColor
			UIView.animate(withDuration: 1.0, delay: 1.0, options: [.curveLinear]) { [weak self] in
				self?.imageView.layer.borderColor = UIColor.clear.cgColor
			}
		}
	}
	// переменная с индексом текущего вопроса
	private var currentQuestionIndex = 0 {
		didSet {
			let delay = currentQuestionIndex == 0 ? 0 : 1.0
			
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self, currentQuestionIndex] in
				self?.yesButton.isEnabled = true
				self?.noButton.isEnabled = true
				self?.showNextQuestionOrResults(nextQuestionIndex: currentQuestionIndex)
			}
		}
	}
	// переменная со счётчиком правильных ответов
	private var correctAnswers = 0
	private let questionsAmount: Int = 10
	private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(controller: self)
	private lazy var questionFactory: QuestionFactoryProtocol = {
		let factory = QuestionFactory()
		factory.delegate = self
		return factory
	}()
	private lazy var statisticService: StatisticServiceProtocol = StatisticService()
	private var currentQuestion: QuizQuestion? {
		didSet {
			guard let currentQuestion else { return }
			let viewModel = convert(model: currentQuestion)
			show(next: viewModel)
		}
	}

	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		questionFactory = {
			let questionFactory = QuestionFactory()
			questionFactory.delegate = self
			return questionFactory
		}()
		alertPresenter = AlertPresenter(controller: self)
		
		showNextQuestionOrResults(nextQuestionIndex: currentQuestionIndex)
    }
	// MARK: - QuestionFactoryDelegate
	func didReceiveNextQuestion(question: QuizQuestion?) {
		currentQuestion = question
	}

	// MARK: - IBActions
	@IBAction private func anyButtonTouchUp(_ sender: UIButton) {
		guard let currentQuestion else { return }
		let givenAnswer = sender.accessibilityIdentifier == "yesButton"
		let isCorrect = givenAnswer == currentQuestion.correctAnswer
		if isCorrect {
			correctAnswers += 1
		}
		imageBorderColor = isCorrect ? .ypGreen : .ypRed
		currentQuestionIndex += 1
	}
	@IBAction private func anyButtonTouchDown(_ sender: UIButton) {
		yesButton.isEnabled = false
		noButton.isEnabled = false
	}

	// MARK: - Private Methods
	private func showNextQuestionOrResults(nextQuestionIndex: Int) {
		if currentQuestionIndex == questionsAmount {
			// идём в состояние "Результат квиза"
			statisticService.store(correct: correctAnswers, total: questionsAmount)
			let text = """
				Ваш результат: \(correctAnswers)/\(questionsAmount)
				Колличество сыгранных квизов: \(statisticService.gamesCount)
				Рекорд: \(statisticService.bestGame?.description ?? "-")
				Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
				"""
			let viewModel = QuizResultsViewModel(
				title: "Этот раунд окончен!",
				text: text,
				buttonText: "Сыграть ещё раз")
			show(result: viewModel)
		} else {
			questionFactory.requestNextQuestion()
		}
	}
	private func convert(model: QuizQuestion) -> QuizStepViewModel {
		let questionStep = QuizStepViewModel(
			image: UIImage(named: model.image) ?? UIImage(),
			question: model.text,
			questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
		return questionStep
	}
	private func show(next step: QuizStepViewModel) {
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			self.imageView.image = step.image
			self.textLabel.text = step.question
			self.counterLabel.text = step.questionNumber
		}
	}
	private func show(result: QuizResultsViewModel) {
		let model = AlertModel(result) { [weak self] _ in
			guard let self else { return }
			self.currentQuestionIndex = 0
			self.correctAnswers = 0
		}
		alertPresenter.present(alert: model)
	}
}

import UIKit

final class MovieQuizViewController: UIViewController {
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
	private var questionFactory: QuestionFactory = QuestionFactory()
	private var currentQuestion: QuizQuestion? {
		didSet {
			guard let currentQuestion else { return }
			let viewModel = convert(model: currentQuestion)
			show(quiz: viewModel)
		}
	}
	
	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		showNextQuestionOrResults(nextQuestionIndex: currentQuestionIndex)
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
			let text = "Ваш результат: \(correctAnswers)/10"
			let viewModel = QuizResultsViewModel(
				title: "Этот раунд окончен!",
				text: text,
				buttonText: "Сыграть ещё раз")
			show(quiz: viewModel)
		} else if let currentQuestion = questionFactory.requestNextQuestion() {
			self.currentQuestion = currentQuestion
		}
	}
	private func convert(model: QuizQuestion) -> QuizStepViewModel {
		let questionStep = QuizStepViewModel(
			image: UIImage(named: model.image) ?? UIImage(),
			question: model.text,
			questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
		return questionStep
	}
	private func show(quiz step: QuizStepViewModel) {
		imageView.image = step.image
		textLabel.text = step.question
		counterLabel.text = step.questionNumber
	}
	private func show(quiz result: QuizResultsViewModel) {
		let alert = UIAlertController(
			title: result.title,
			message: result.text,
			preferredStyle: .alert)
		
		let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
			self?.currentQuestionIndex = 0
			self?.correctAnswers = 0
		}
		
		alert.addAction(action)
		
		self.present(alert, animated: true, completion: nil)
	}
}

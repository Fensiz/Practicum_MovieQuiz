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
			var delay = currentQuestionIndex == 0 ? 0 : 1.0
			
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self, currentQuestionIndex] in
				self?.yesButton.isEnabled = true
				self?.noButton.isEnabled = true
				self?.showNextQuestionOrResults(nextQuestionIndex: currentQuestionIndex)
			}
		}
	}
	// переменная со счётчиком правильных ответов
	private var correctAnswers = 0
	// массив вопросов
	private let questions: [QuizQuestion] = [
		QuizQuestion(
			image: "The Godfather",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		QuizQuestion(
			image: "The Dark Knight",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		QuizQuestion(
			image: "Kill Bill",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		QuizQuestion(
			image: "The Avengers",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		QuizQuestion(
			image: "Deadpool",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		QuizQuestion(
			image: "The Green Knight",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		QuizQuestion(
			image: "Old",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: false),
		QuizQuestion(
			image: "The Ice Age Adventures of Buck Wild",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: false),
		QuizQuestion(
			image: "Tesla",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: false),
		QuizQuestion(
			image: "Vivarium",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: false)
	]
	
	
	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		showNextQuestionOrResults(nextQuestionIndex: currentQuestionIndex)
    }
	
	// MARK: - IBActions
	@IBAction private func anyButtonTouchUp(_ sender: UIButton) {
		let currentQuestion = questions[currentQuestionIndex]
		let givenAnswer = sender.titleLabel?.text == "Да"
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
		if nextQuestionIndex == questions.count {
			// идём в состояние "Результат квиза"
			let text = "Ваш результат: \(correctAnswers)/10"
			let viewModel = QuizResultsViewModel(
				title: "Этот раунд окончен!",
				text: text,
				buttonText: "Сыграть ещё раз")
			show(quiz: viewModel)
		} else {
			let nextQuestion = questions[nextQuestionIndex]
			let viewModel = convert(model: nextQuestion)
			show(quiz: viewModel)
		}
	}
	private func convert(model: QuizQuestion) -> QuizStepViewModel {
		let questionStep = QuizStepViewModel(
			image: UIImage(named: model.image) ?? UIImage(),
			question: model.text,
			questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
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
		
		let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
			self.currentQuestionIndex = 0
			self.correctAnswers = 0
		}
		
		alert.addAction(action)
		
		self.present(alert, animated: true, completion: nil)
	}
}

struct QuizQuestion {
	// строка с названием фильма,
	// совпадает с названием картинки афиши фильма в Assets
	let image: String
	// строка с вопросом о рейтинге фильма
	let text: String
	// булевое значение (true, false), правильный ответ на вопрос
	let correctAnswer: Bool
}
// вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
	// картинка с афишей фильма с типом UIImage
	let image: UIImage
	// вопрос о рейтинге квиза
	let question: String
	// строка с порядковым номером этого вопроса (ex. "1/10")
	let questionNumber: String
}
struct QuizResultsViewModel {
	// строка с заголовком алерта
	let title: String
	// строка с текстом о количестве набранных очков
	let text: String
	// текст для кнопки алерта
	let buttonText: String
}

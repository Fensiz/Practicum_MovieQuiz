import UIKit

final class MovieQuizViewController: UIViewController {

	// MARK: - IB Outlets

	@IBOutlet weak private var imageView: UIImageView!
	@IBOutlet weak private var textLabel: UILabel!
	@IBOutlet weak private var counterLabel: UILabel!
	@IBOutlet weak private var noButton: UIButton!
	@IBOutlet weak private var yesButton: UIButton!
	@IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

	// MARK: - Properties

	private var imageBorderColor: UIColor = .clear {
		didSet {
			imageView.layer.borderColor = imageBorderColor.cgColor
			UIView.animate(withDuration: 1.0, delay: 1.0, options: [.curveLinear]) { [weak self] in
				self?.imageView.layer.borderColor = UIColor.clear.cgColor
			}
		}
	}

	private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(controller: self)

	private var presenter: MovieQuizPresenter? {
		didSet {
			showLoadingIndicator()
		}
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		textLabel.text = ""
		presenter = MovieQuizPresenter(viewController: self)
	}

	// MARK: - IBActions

	@IBAction private func anyButtonTouchUp(_ sender: UIButton) {
		let givenAnswer = sender.accessibilityIdentifier == "YesButton"
		presenter?.process(answer: givenAnswer)
	}

	@IBAction private func anyButtonTouchDown(_ sender: UIButton) {
		yesButton.isEnabled = false
		noButton.isEnabled = false
	}

	@IBAction private func anyButtonTouchUpOutside(_ sender: UIButton) {
		yesButton.isEnabled = true
		noButton.isEnabled = true
	}
}

extension MovieQuizViewController: MovieQuizViewProtocol {

	// MARK: - Public Methods

	func show(next step: QuizStepViewModel) {
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			self.imageView.image = step.image
			self.textLabel.text = step.question
			self.counterLabel.text = step.questionNumber
			self.yesButton.isEnabled = true
			self.noButton.isEnabled = true
		}
	}

	func show(result: QuizResultsViewModel) {
		DispatchQueue.main.async { [weak self, weak presenter] in
			let model = AlertModel(result) { _ in
				presenter?.restartQuiz()
			}
			self?.alertPresenter.present(alert: model)
		}
	}

	func show(networkError error: any Error) {
		DispatchQueue.main.async { [weak self, weak presenter] in
			self?.hideLoadingIndicator()

			let model = AlertModel(
				title: "Ошибка",
				message: error.localizedDescription,
				buttonText: "Попробовать еще раз"
			) { _ in
				guard
					let self,
					let presenter
				else { return }
				self.showLoadingIndicator()
				presenter.handleErrorAndRetry(error)
			}
			self?.alertPresenter.present(alert: model)
		}
	}

	func updateBorderColor(isCorrect: Bool) {
		DispatchQueue.main.async { [weak self] in
			self?.imageBorderColor = isCorrect ? .ypGreen : .ypRed
		}
	}

	func showLoadingIndicator() {
		DispatchQueue.main.async { [weak self] in
			self?.activityIndicator.startAnimating()
		}
	}

	func hideLoadingIndicator() {
		DispatchQueue.main.async { [weak self] in
			self?.activityIndicator.stopAnimating()
		}
	}
}

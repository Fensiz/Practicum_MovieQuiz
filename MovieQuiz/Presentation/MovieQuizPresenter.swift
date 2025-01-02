//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 01.01.2025.
//
import UIKit

final class MovieQuizPresenter {
	private var questionFactory: QuestionFactoryProtocol?
	private weak var viewController: MovieQuizViewController?
	private var correctAnswers = 0
	private let questionsAmount = 10
	private lazy var statisticService: StatisticServiceProtocol = StatisticService()

	init(viewController: MovieQuizViewController? = nil) {
		self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
		self.viewController = viewController
		questionFactory?.loadData()
	}


	private var currentQuestion: QuizQuestion? {
		didSet {
			guard let currentQuestion else { return }
			let viewModel = convert(model: currentQuestion)
			viewController?.show(next: viewModel)
		}
	}

	private var currentQuestionIndex = 0 {
		didSet {
			let delay = currentQuestionIndex == 0 ? 0 : 1.0

			DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self, currentQuestionIndex] in
				self?.showNextQuestionOrResults(nextQuestionIndex: currentQuestionIndex)
			}
		}
	}

	func handleError(_ error: any Error) {
		switch error {
			case QuestionFactory.LoadError.imageLoadError:
				questionFactory?.requestNextQuestion()
			default:
				questionFactory?.loadData()
		}
	}

	func restartQuiz() {
		currentQuestionIndex = 0
		correctAnswers = 0
	}

	func process(answer: Bool) {
		let isCorrect = answer == currentQuestion?.correctAnswer
		if isCorrect {
			correctAnswers += 1
		}
		viewController?.updateBorderColor(isCorrect: isCorrect)
		currentQuestionIndex += 1
	}

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
			viewController?.show(result: viewModel)
		} else {
			viewController?.showLoadingIndicator()
			questionFactory?.requestNextQuestion()
		}
	}
	private func convert(model: QuizQuestion) -> QuizStepViewModel {
		let questionStep = QuizStepViewModel(
			image: UIImage(data: model.image) ?? UIImage(),
			question: model.text,
			questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
		return questionStep
	}
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
	// MARK: - QuestionFactoryDelegate

	func didReceiveNextQuestion(question: QuizQuestion?) {
		viewController?.hideLoadingIndicator()
		currentQuestion = question
	}

	func didLoadDataFromServer() {
		questionFactory?.requestNextQuestion()
	}

	func didFailToLoadData(with error: any Error) {
		viewController?.show(networkError: error)
	}
}

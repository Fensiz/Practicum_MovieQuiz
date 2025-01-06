//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 24.11.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
	private let moviesLoader: MoviesLoading
	weak var delegate: QuestionFactoryDelegate?
	private var movies: [MostPopularMovie] = []
	private var min = 0
	private var max = 0

	init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
		self.moviesLoader = moviesLoader
		self.delegate = delegate
	}

	// MARK: - Errors

	enum LoadError: Error, LocalizedError {
		case movieListLoadError(error: Error)
		case apiError(message: String)
		case imageLoadError
		var errorDescription: String? {
			switch self {
				case .apiError(let message):
					"ApiError: \(message)"
				case .movieListLoadError(let error):
					error.localizedDescription
				case .imageLoadError:
					"Image loading went wrong"
			}
		}
	}

	// MARK: - Data Loading

	func loadData() {
		moviesLoader.loadMovies { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let mostPopularMovies):
					self.handleSuccess(mostPopularMovies)
				case .failure(let error):
					self.handleFailure(error)
			}
		}
	}

	func requestNextQuestion() {
		Utils.debugPrint(">>>>REQ")
		DispatchQueue.global().async { [weak self] in
			Utils.debugPrint("Movies count: \(self?.movies.count ?? 0)")
			guard let self = self, let movie = self.movies.randomElement() else { return }
			self.createQuestion(for: movie)
		}
	}

	// MARK: - Result Handlers

	private func handleSuccess(_ mostPopularMovies: MostPopularMovies) {
		Utils.debugPrint("SUCCESS")
		guard mostPopularMovies.errorMessage.isEmpty else {
			delegate?.didFailToLoadData(
				with: LoadError.apiError(message: mostPopularMovies.errorMessage)
			)
			return
		}

		guard !mostPopularMovies.items.isEmpty else {
			delegate?.didFailToLoadData(
				with: LoadError.apiError(message: "No movies found")
			)
			return
		}

		let ratings = mostPopularMovies.items
			.compactMap { Float($0.rating) }
			.map { Int($0 * 10) }

		min = ratings.min() ?? 0
		max = ratings.max() ?? 0
		movies = mostPopularMovies.items
		delegate?.didLoadDataFromServer()
	}

	private func handleFailure(_ error: Error) {
		Utils.debugPrint("FAIL")
		delegate?.didFailToLoadData(
			with: LoadError.movieListLoadError(error: error)
		)
	}

	// MARK: - Question Generation

	private func createQuestion(for movie: MostPopularMovie) {
		guard let imageData = try? Data(contentsOf: movie.resizedImageURL) else {
			delegate?.didFailToLoadData(with: LoadError.imageLoadError)
			return
		}

		let (text, correctAnswer) = generateQuestionTextAndAnswer(for: movie)

		let question = QuizQuestion(
			image: imageData,
			text: text,
			correctAnswer: correctAnswer
		)
		Utils.debugPrint(text, correctAnswer)

		delegate?.didReceiveNextQuestion(question: question)
	}

	private func generateQuestionTextAndAnswer(
		for movie: MostPopularMovie
	) -> (text: String, correctAnswer: Bool) {
		let rating = Int((Float(movie.rating) ?? 0) * 10)
		Utils.debugPrint("Rat:", rating, "Min:", min, "Max:", max)
		let questionRating = (min...max).filter({$0 != rating}).randomElement() ?? (max - min) / 2
		let isGreater = Bool.random()
		let text = "Рейтинг этого фильма \(isGreater ? "больше" : "меньше")" +
		" чем \(String(format: "%.1f", Float(questionRating) / 10))?"
		let correctAnswer = (rating > questionRating) == isGreater
		return (text, correctAnswer)
	}
}

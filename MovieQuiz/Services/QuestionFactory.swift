//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 24.11.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
	private let moviesLoader: MoviesLoading
	private weak var delegate: QuestionFactoryDelegate?
	private var movies: [MostPopularMovie] = []
	private var min = 0
	private var max = 0

	init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
		self.moviesLoader = moviesLoader
		self.delegate = delegate
	}

	enum LoadError: Error, LocalizedError {
		case movieListLoadError(error: Error)
		case apiError(message: String)
		case imageLoadError
		var errorDescription: String {
			switch self {
				case .apiError(let message):
					return message
				case .movieListLoadError(let error):
					return error.localizedDescription
				case .imageLoadError:
					return "Image loading went wrong"
			}
		}
	}

	func loadData() {
		moviesLoader.loadMovies { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let mostPopularMovies):
					Utils.debugPrint("SUCCESS")
					if !mostPopularMovies.errorMessage.isEmpty {
						self.delegate?.didFailToLoadData(
							with: LoadError.apiError(
								message: mostPopularMovies.errorMessage
							)
						)
					} else if mostPopularMovies.items.isEmpty {
						self.delegate?.didFailToLoadData(
							with: LoadError.apiError(
								message: "No movies found"
							)
						)
					}
					let ratings = mostPopularMovies.items
						.compactMap({Float($0.rating)})
						.compactMap({Int($0 * 10)})
					self.min = ratings.min() ?? 0
					self.max = ratings.max() ?? 0
					self.movies = mostPopularMovies.items
					self.delegate?.didLoadDataFromServer()
				case .failure(let error):
					Utils.debugPrint("FAIL")
					self.delegate?.didFailToLoadData(
						with: LoadError.movieListLoadError(
							error: error
						)
					)
			}
		}
	}
	func requestNextQuestion() {
		Utils.debugPrint(">>>>REQ")
		DispatchQueue.global().async { [weak self] in
			Utils.debugPrint("Movies count: \(self?.movies.count ?? 0)")
			guard
				let self = self,
				let movie = self.movies.randomElement()
			else {
				return
			}

			var imageData = Data()

			do {
				imageData = try Data(contentsOf: movie.resizedImageURL)
			} catch {
				self.delegate?.didFailToLoadData(with: LoadError.imageLoadError)
				return
			}

			let (text, correctAnswer) = getQuestionTextAndAnswer(movie)

			let question = QuizQuestion(
				image: imageData,
				text: text,
				correctAnswer: correctAnswer
			)
			Utils.debugPrint(text, correctAnswer)

			self.delegate?.didReceiveNextQuestion(question: question)
		}
	}

	private func getQuestionTextAndAnswer(_ movie: MostPopularMovie) -> (text: String, correctAnswer: Bool) {
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

//	оставлено до следующего спринта
//	private let questions: [QuizQuestion] = [
//		QuizQuestion(
//			image: "The Godfather",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		QuizQuestion(
//			image: "The Dark Knight",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		QuizQuestion(
//			image: "Kill Bill",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		QuizQuestion(
//			image: "The Avengers",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		QuizQuestion(
//			image: "Deadpool",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		QuizQuestion(
//			image: "The Green Knight",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		QuizQuestion(
//			image: "Old",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//		QuizQuestion(
//			image: "The Ice Age Adventures of Buck Wild",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//		QuizQuestion(
//			image: "Tesla",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//		QuizQuestion(
//			image: "Vivarium",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false)
//	]

//
//  MovieLoader.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 18.12.2024.
//

import Foundation

protocol MoviesLoading {
	func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
	// MARK: - NetworkClient
	private let networkClient = NetworkClient()

	// MARK: - URL
	private var mostPopularMoviesUrl: URL {
		// Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
		guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_kiwxbi4y") else {
			preconditionFailure("Unable to construct mostPopularMoviesUrl")
		}
		return url
	}

	func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
		networkClient.fetch(url: mostPopularMoviesUrl) { result in

			switch result {
				case .success(let mostPopularMovies):
					do {
						var movies = try JSONDecoder().decode(MostPopularMovies.self, from: mostPopularMovies)
						handler(.success(movies))
					} catch {
						handler(.failure(error))
					}
				case .failure(let error):
					handler(.failure(error))
			}
		}
	}
}

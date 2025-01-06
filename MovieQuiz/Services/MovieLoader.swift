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

	// MARK: - Properties

	private let networkClient = NetworkClient()
	private var mostPopularMoviesUrl: URL {
		guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
			preconditionFailure("Unable to construct mostPopularMoviesUrl")
		}
		return url
	}

	// MARK: - Public Methods

	func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
		networkClient.fetch(url: mostPopularMoviesUrl) { result in

			switch result {
				case .success(let mostPopularMovies):
					do {
						let movies = try JSONDecoder().decode(
							MostPopularMovies.self,
							from: mostPopularMovies
						)
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

//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 18.12.2024.
//

import Foundation

struct MostPopularMovies: Codable {
	let errorMessage: String
	let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
	let title: String
	let rating: String
	let imageURL: URL

	private enum CodingKeys: String, CodingKey {
		case title = "fullTitle"
		case rating = "imDbRating"
		case imageURL = "image"
	}
}

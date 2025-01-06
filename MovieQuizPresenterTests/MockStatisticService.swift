//
//  Untitled.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 02.01.2025.
//

import XCTest
@testable import MovieQuiz

final class MockStatisticService: StatisticServiceProtocol {
	
	var gamesCount = 0
	var totalAccuracy: Double = 0
	var bestGame: GameResult?

	func store(correct: Int, total: Int) {
		gamesCount += 1
	}
}

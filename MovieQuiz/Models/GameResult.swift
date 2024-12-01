//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 29.11.2024.
//

import Foundation

struct GameResult {
	let correct: Int
	let total: Int
	let date: Date
	var description: String {
		"\(correct)/\(total) (\(date.dateTimeString))"
	}
	
	// метод сравнения по количеству верных ответов
	func isBetterThan(_ another: GameResult?) -> Bool {
		guard let another else { return true }
		return correct > another.correct
	}
}

//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 29.11.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
	// MARK: - Public Properties
	var totalAccuracy: Double {
		guard gamesCount > 0 else { return 0 }
		#if DEBUG
		print("correct: \(totalCorrect) games: \(gamesCount) %:\(Double(totalCorrect) / Double(gamesCount) * 10)")
		#endif
		return Double(totalCorrect) / Double(gamesCount) * 10
	}
	private(set) var gamesCount: Int {
		get {
			storage.integer(forKey: .gamesCount)
		}
		set {
			storage.set(newValue, forKey: .gamesCount)
		}
	}
	private(set) var bestGame: GameResult? {
		get {
			guard gamesCount > 0 else { return nil }
			let correct: Int = storage.integer(forKey: .bestCorrect)
			let total: Int = storage.integer(forKey: .bestTotal)
			let date: Date = storage.object(forKey: .bestDate) as? Date ?? Date()
			return .init(correct: correct, total: total, date: date)
		}
		set {
			guard let newValue, newValue.isBetterThan(bestGame) else { return }
			storage.set(newValue.correct, forKey: .bestCorrect)
			storage.set(newValue.total, forKey: .bestTotal)
			storage.set(newValue.date, forKey: .bestDate)
		}
	}

	// MARK: - Private Properties
	private let storage: UserDefaults = .standard
	private var totalCorrect: Int {
		get {
			storage.integer(forKey: .totalCorrect)
		}
		set {
			storage.set(newValue, forKey: .totalCorrect)
		}
	}

	// MARK: - Public Methods
	func store(correct count: Int, total amount: Int) {
		let date = Date()
		let gameResult: GameResult = .init(correct: count, total: amount, date: date)
		bestGame = gameResult
		gamesCount += 1
		totalCorrect += count
	}
}

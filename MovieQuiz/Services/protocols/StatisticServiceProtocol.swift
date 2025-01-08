//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 29.11.2024.
//

protocol StatisticServiceProtocol: AnyObject {
	var totalAccuracy: Double { get }
	var gamesCount: Int { get }
	var bestGame: GameResult? { get }

	func store(correct count: Int, total amount: Int)
}

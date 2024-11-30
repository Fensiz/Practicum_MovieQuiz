//
//  UserDefaults+Extensions.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 30.11.2024.
//

import Foundation

extension UserDefaults {
	enum Key: String {
		case gamesCount, bestCorrect, bestTotal, bestDate, totalCorrect, total
	}

	// Сохранение значения с использованием enum
	func set(_ value: Int, forKey key: Key) {
		self.set(value, forKey: key.rawValue)
	}
	func set(_ value: Any?, forKey key: Key) {
		self.set(value, forKey: key.rawValue)
	}

	// Получение значения с использованием enum
	func integer(forKey key: Key) -> Int {
		return self.integer(forKey: key.rawValue)
	}
	func object(forKey key: Key) -> Any? {
		return self.object(forKey: key.rawValue)
	}
}

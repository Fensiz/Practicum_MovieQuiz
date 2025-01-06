//
//  Utils.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 22.12.2024.
//

struct Utils {
	private init() {}
	static func debugPrint(_ items: Any...) {
#if DEBUG
		let message = items.map { "\($0)" }.joined(separator: " ")
		print(message)
#endif
	}
}

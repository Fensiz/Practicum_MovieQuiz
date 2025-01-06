//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 24.11.2024.
//

protocol QuestionFactoryProtocol: AnyObject {
	func requestNextQuestion()
	func loadData()
}

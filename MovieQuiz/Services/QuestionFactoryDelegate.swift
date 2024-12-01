//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 25.11.2024.
//

protocol QuestionFactoryDelegate: AnyObject {
	func didReceiveNextQuestion(question: QuizQuestion?)
}

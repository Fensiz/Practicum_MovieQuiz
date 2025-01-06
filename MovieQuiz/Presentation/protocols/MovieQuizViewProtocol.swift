//
//  MovieQuizViewProtocol.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 02.01.2025.
//

protocol MovieQuizViewProtocol: AnyObject {
	func show(next step: QuizStepViewModel)
	func show(result: QuizResultsViewModel)
	func show(networkError: Error)
	func updateBorderColor(isCorrect: Bool)
	func showLoadingIndicator()
	func hideLoadingIndicator()
}

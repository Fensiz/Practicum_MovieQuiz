//
//  MockQuestionFactory.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 02.01.2025.
//

@testable import MovieQuiz

final class MockQuestionFactory: QuestionFactoryProtocol {
	var isRequestNextQuestionCalled = false
	var isLoadDataCalled = false

	func requestNextQuestion() {
		isRequestNextQuestionCalled = true
	}

	func loadData() {
		isLoadDataCalled = true
	}
}

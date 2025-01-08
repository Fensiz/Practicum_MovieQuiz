//
//  MockClasses.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 02.01.2025.
//

import XCTest
@testable import MovieQuiz

final class MockViewController: MovieQuizViewProtocol {
	var isShowNextCalled = false
	var isShowResultCalled = false
	var isShowLoadingIndicatorCalled = false
	var isHideLoadingIndicatorCalled = false
	var isUpdateBorderColorCalled = false
	var lastViewModel: QuizStepViewModel?
	var lastResultViewModel: QuizResultsViewModel?

	func show(next step: QuizStepViewModel) {
		isShowNextCalled = true
		lastViewModel = step
	}

	func show(result: QuizResultsViewModel) {
		isShowResultCalled = true
		lastResultViewModel = result
	}

	func showLoadingIndicator() {
		isShowLoadingIndicatorCalled = true
	}

	func hideLoadingIndicator() {
		isHideLoadingIndicatorCalled = true
	}

	func updateBorderColor(isCorrect: Bool) {
		isUpdateBorderColorCalled = true
	}

	func show(networkError error: any Error) {}
}





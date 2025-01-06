//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Симонов Иван Дмитриевич on 02.01.2025.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
	var presenter: MovieQuizPresenter!
	var mockViewController: MockViewController!
	var mockQuestionFactory: MockQuestionFactory!
	var mockStatisticService: MockStatisticService!

	override func setUp() {
		mockViewController = MockViewController()
		mockQuestionFactory = MockQuestionFactory()
		mockStatisticService = MockStatisticService()
		presenter = MovieQuizPresenter(
			viewController: mockViewController,
			questionFactory: mockQuestionFactory,
			statisticService: mockStatisticService
		)
	}

	override func tearDown() {
		mockViewController = nil
		mockQuestionFactory = nil
		mockStatisticService = nil
		presenter = nil
	}

	func testPresenterConvertModel() throws {
		let emptyData = Data()
		let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
		let viewModel = presenter.convert(model: question)

		XCTAssertNotNil(viewModel.image)
		XCTAssertEqual(viewModel.question, "Question Text")
		XCTAssertEqual(viewModel.questionNumber, "1/10")
	}

	func testPresenterLoadsDataOnInit() {
		XCTAssertTrue(mockQuestionFactory.isLoadDataCalled)
	}

	func testPresenterShowsNextQuestion() {
		let question = QuizQuestion(image: Data(), text: "Test", correctAnswer: true)
		presenter.didReceiveNextQuestion(question: question)

		XCTAssertTrue(mockViewController.isShowNextCalled)
		XCTAssertEqual(mockViewController.lastViewModel?.question, "Test")
	}

	func testPresenterShowsResultAfterLastQuestion() {
		for _ in 1...10 {
			presenter.process(answer: true)
		}

		let expectation = self.expectation(description: "Ожидание завершения DispatchQueue.main.async")

		DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 5.0)
		XCTAssertTrue(mockViewController.isShowResultCalled)
		XCTAssertEqual(mockViewController.lastResultViewModel?.title, "Этот раунд окончен!")
	}

}

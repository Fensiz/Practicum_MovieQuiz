//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Симонов Иван Дмитриевич on 28.12.2024.
//

import XCTest

final class MovieQuizTests: XCTestCase {
	var app: XCUIApplication!

    override func setUpWithError() throws {
		try super.setUpWithError()
        continueAfterFailure = false

		app = XCUIApplication()
		app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		try super.tearDownWithError()

		app.terminate()
		app = nil
    }

	@MainActor
	func testImageSwitchWithYesButton() throws {
		sleep(3)
		let firstImage = app.images["Poster"].screenshot().pngRepresentation

		app.buttons["YesButton"].tap()

		sleep(3)
		let secondImage = app.images["Poster"].screenshot().pngRepresentation

		XCTAssertNotEqual(firstImage, secondImage)
	}

	@MainActor
	func testImageSwitchWithNoButton() throws {
		sleep(3)
		let firstImage = app.images["Poster"].screenshot().pngRepresentation

		app.buttons["NoButton"].tap()

		sleep(3)
		let secondImage = app.images["Poster"].screenshot().pngRepresentation

		XCTAssertNotEqual(firstImage, secondImage)
	}

	@MainActor
	func testAlertAppeared() throws {
		let button = app.buttons["NoButton"]

		for _ in 0..<10 {
			button.tap()
			sleep(2)
		}

		let alert = app.alerts["Result"]
		XCTAssertTrue(alert.exists)
		XCTAssertTrue(alert.label == "Этот раунд окончен!")
		XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
	}

	@MainActor
	func testAlertDismiss() throws {
		let button = app.buttons["NoButton"]

		for _ in 0..<10 {
			button.tap()
			sleep(2)
		}

		app.alerts["Result"].buttons.firstMatch.tap()

		sleep(2)

		XCTAssertEqual(app.staticTexts["Index"].label, "1/10")
	}

	@MainActor
	func testAlertNotAppeared() throws {
		let button = app.buttons["NoButton"]

		for _ in 0..<2 {
			button.tap()
			sleep(2)
		}

		XCTAssertFalse(app.alerts["Result"].exists)
	}

	@MainActor
	func testIndexIncreased() throws {
		app.buttons["YesButton"].tap()
		sleep(2)
		XCTAssertEqual(app.staticTexts["Index"].label, "2/10")
	}

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
	

}

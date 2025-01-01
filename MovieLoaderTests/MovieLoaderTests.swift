//
//  MovieLoaderTests.swift
//  MovieLoaderTests
//
//  Created by Симонов Иван Дмитриевич on 28.12.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieLoaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testSuccessLoading() throws {
		// Given
		let stubNetworkClient = StubNetworkClient(emulateError: false) // говорим, что не хотим эмулировать ошибку
		let loader = MoviesLoader(networkClient: stubNetworkClient)

		// When
		let expectation = expectation(description: "Loading expectation")

		loader.loadMovies { result in
			// Then
			switch result {
				case .success(let movies):
					// давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
					XCTAssertEqual(movies.items.count, 2)
					expectation.fulfill()
				case .failure(_):
					XCTFail("Unexpected failure")
			}
		}

		waitForExpectations(timeout: 1)
	}

	func testFailLoading() throws {
		// Given
		let stubNetworkClient = StubNetworkClient(emulateError: true) // говорим, что не хотим эмулировать ошибку
		let loader = MoviesLoader(networkClient: stubNetworkClient)

		// When
		let expectation = expectation(description: "Loading expectation")

		loader.loadMovies { result in
			// Then
			switch result {
				case .success(_):
					XCTFail("Unexpected failure")
				case .failure(let error):
					XCTAssertNotNil(error)
					expectation.fulfill()
			}
		}

		waitForExpectations(timeout: 1)
	}

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

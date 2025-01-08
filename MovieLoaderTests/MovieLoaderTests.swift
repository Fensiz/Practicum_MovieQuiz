//
//  MovieLoaderTests.swift
//  MovieLoaderTests
//
//  Created by Симонов Иван Дмитриевич on 28.12.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieLoaderTests: XCTestCase {
	func testSuccessLoading() throws {
		// Given
		let stubNetworkClient = StubNetworkClient(emulateError: false)
		let loader = MoviesLoader(networkClient: stubNetworkClient)

		// When
		let expectation = expectation(description: "Loading expectation")

		loader.loadMovies { result in
			// Then
			switch result {
				case .success(let movies):
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
		let stubNetworkClient = StubNetworkClient(emulateError: true)
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
}

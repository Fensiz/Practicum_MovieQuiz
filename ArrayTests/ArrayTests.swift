//
//  ArrayTests.swift
//  ArrayTests
//
//  Created by Симонов Иван Дмитриевич on 26.12.2024.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
	func testGetValueInRange() throws {
		//Given
		let array: [Int] = [1, 2, 3]

		//When
		let value = array[safe: 2]

		//Then
		XCTAssertEqual(value, 3)
	}
	func testGetValueOutOfRange() throws {
		//Given
		let array = [1, 2, 3]

		//When
		let value = array[safe: 4]

		//Then
		XCTAssertNil(value)
	}
}

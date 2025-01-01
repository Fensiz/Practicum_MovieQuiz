//
//  ArrayTests.swift
//  ArrayTests
//
//  Created by Симонов Иван Дмитриевич on 26.12.2024.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testGetValueInRange() throws {
		//Given
		let array: [Int] = [1, 2, 3]

		//When
		let value = array[2]

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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

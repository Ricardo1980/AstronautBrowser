//
//  AstronautServiceURLFactoryTests.swift
//  AstronautBrowserTests
//
//  Created by Ricardo on 24/01/2023.
//

import XCTest
@testable import AstronautBrowser

final class AstronautServiceURLFactoryTests: XCTestCase {

    func testMakeAstronautsURLWithCorrectParameters() throws {
        let sut = AstronautServiceURLFactory(baseURL: URL(string: "https://www.test.com/v1")!)
        let url = try sut.makeAstronautsURL(offset: 0, limit: 10, filters: nil)

        XCTAssertEqual(url, URL(string: "https://www.test.com/v1/astronaut?offset=0&limit=10"))
    }

    func testMakeAstronautsURLWithCorrectParametersAndFiltering() throws {
        let sut = AstronautServiceURLFactory(baseURL: URL(string: "https://www.test.com/v1")!)
        let url = try sut.makeAstronautsURL(offset: 0, limit: 10, filters: [.deceased, .diedWhileInActiveService])

        XCTAssertEqual(url, URL(string: "https://www.test.com/v1/astronaut?offset=0&limit=10&status_ids=11,6"))
    }

    func testMakeAstronautsURLWithIncorrectOffset() {
        let sut = AstronautServiceURLFactory(baseURL: URL(string: "https://www.test.com/v1")!)

        XCTAssertThrowsError(try sut.makeAstronautsURL(offset: -10, limit: 10, filters: nil)) { error in
            XCTAssertEqual(error as? AstronautServiceURLError, AstronautServiceURLError.invalidOffset)
        }
    }

    func testMakeAstronautsURLWithIncorrectLimit() {
        let sut = AstronautServiceURLFactory(baseURL: URL(string: "https://www.test.com/v1")!)

        XCTAssertThrowsError(try sut.makeAstronautsURL(offset: 10, limit: -10, filters: nil)) { error in
            XCTAssertEqual(error as? AstronautServiceURLError, AstronautServiceURLError.invalidLimit)
        }
    }

    func testMakeAstronautURL() {
        let sut = AstronautServiceURLFactory(baseURL: URL(string: "https://www.test.com/v1")!)
        XCTAssertEqual(sut.makeAstronautURL(id: 1234), URL(string: "https://www.test.com/v1/astronaut/1234"))
    }
}

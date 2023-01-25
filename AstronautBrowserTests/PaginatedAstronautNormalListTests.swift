//
//  PaginatedAstronautNormalListTests.swift
//  AstronautBrowserTests
//
//  Created by Ricardo on 24/01/2023.
//

import XCTest
@testable import AstronautBrowser

final class PaginatedAstronautNormalListTests: XCTestCase {

    func testDecodingSuccessfully() throws {
        guard let url = Bundle(for: Self.self).url(forResource: "paginated_astronaut_normal_list_first_page", withExtension: "json") else {
            XCTFail("Cannot generate json URL")
            return
        }

        let data = try Data(contentsOf: url)
        let paginatedAstronautNormalList = try JSONDecoder().decode(PaginatedAstronautNormalList.self, from: data)

        XCTAssertEqual(paginatedAstronautNormalList.count, 721)
        XCTAssertEqual(paginatedAstronautNormalList.next, URL(string: "https://lldev.thespacedevs.com/2.2.0/astronaut/?limit=20&offset=20"))
        XCTAssertNil(paginatedAstronautNormalList.previous)
        XCTAssertEqual(paginatedAstronautNormalList.results.count, 20)
    }

    func testDecodingFailureWhenResultFieldIsMissing() {
        let jsonString = """
        {
            "count": 721,
            "next": "https://lldev.thespacedevs.com/2.2.0/astronaut/?limit=10&offset=20",
            "previous": "https://lldev.thespacedevs.com/2.2.0/astronaut/?limit=10",
        }
        """

        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Cannot convert json to data")
            return
        }

        XCTAssertThrowsError(try JSONDecoder().decode(PaginatedAstronautNormalList.self, from: data)) { error in
            let decodingError = error as? DecodingError
            XCTAssertNotNil(decodingError)
            if case let .keyNotFound(_, context) = decodingError {
                XCTAssertEqual(context.debugDescription, #"No value associated with key CodingKeys(stringValue: "results", intValue: nil) ("results")."#)
            } else {
                XCTFail("Unknown error")
            }
        }
    }
}

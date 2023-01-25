//
//  AstronautDetailTests.swift
//  AstronautBrowserTests
//
//  Created by Ricardo on 24/01/2023.
//

import XCTest
@testable import AstronautBrowser

final class AstronautDetailTests: XCTestCase {

    func testDecodingSuccessfully() throws {
        guard let url = Bundle(for: Self.self).url(forResource: "astronaut_detail", withExtension: "json") else {
            XCTFail("Cannot generate json URL")
            return
        }

        let data = try Data(contentsOf: url)
        let astronautDetail = try JSONDecoder().decode(AstronautDetail.self, from: data)

        XCTAssertEqual(astronautDetail.id, 12)
        XCTAssertEqual(astronautDetail.name, "Alexander Gerst")
        XCTAssertEqual(astronautDetail.agency.id, 27)
        XCTAssertEqual(astronautDetail.agency.name, "European Space Agency")

        var comps = DateComponents()
        comps.day = 03
        comps.month = 05
        comps.year = 1976
        let date = Calendar.current.date(from: comps)!
        XCTAssertEqual(astronautDetail.dateOfBirth, date)

        XCTAssertEqual(astronautDetail.bio.count, 320)
        XCTAssertEqual(
            astronautDetail.profileImageURL,
            URL(string: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/astronaut_images/alexander2520gerst_image_20181127211820.jpg")
        )
        XCTAssertEqual(astronautDetail.twitterURL, URL(string: "https://twitter.com/Astro_Alex"))
        XCTAssertEqual(astronautDetail.instagramURL,URL(string: "https://www.instagram.com/astro_alex_esa/"))
        XCTAssertEqual(astronautDetail.wikiURL, URL(string: "https://en.wikipedia.org/wiki/Alexander_Gerst"))
    }

    func testDecodingFailureWhenSomeMandatoryFieldsAreMissing() {
        let jsonString = """
        {
            "url": "https://lldev.thespacedevs.com/2.2.0/astronaut/12/",
            "name": "Alexander Gerst",
            "status": {
                "id": 1,
                "name": "Active"
            },
            "type": {
                "id": 2,
                "name": "Government"
            }
        }
        """

        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Cannot convert json to data")
            return
        }

        XCTAssertThrowsError(try JSONDecoder().decode(AstronautDetail.self, from: data)) { error in
            let decodingError = error as? DecodingError
            XCTAssertNotNil(decodingError)
            if case .keyNotFound = decodingError {} else {
                XCTFail("Unknown error")
            }
        }
    }
}

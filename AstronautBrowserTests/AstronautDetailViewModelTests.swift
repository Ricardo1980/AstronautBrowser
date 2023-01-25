//
//  AstronautDetailViewModelTests.swift
//  AstronautBrowserTests
//
//  Created by Ricardo on 24/01/2023.
//

import XCTest
import Combine
@testable import AstronautBrowser

final class AstronautDetailViewModelTests: XCTestCase {

    var subscriptions = Set<AnyCancellable>()

    func testIdleState() {
        let astronautServiceMock = AstronautServiceMock()
        let sut = AstronautDetailViewModel(astronautId: 12, astronautService: astronautServiceMock)
        XCTAssertEqual(sut.state, .idle)
    }

    func testFetchingSuccessSequence() {
        let expectation = expectation(description: "Sequence ended")

        let astronautServiceMock = AstronautServiceMock()
        astronautServiceMock.fetchAstronautResult = .success(AstronautDetail.mock)
        let sut = AstronautDetailViewModel(astronautId: 12, astronautService: astronautServiceMock)

        var statesEmitted: [AstronautDetailViewModel.State] = []

        sut.$state.sink(receiveValue: { value in
            statesEmitted.append(value)
            if statesEmitted.count == 3 {
                expectation.fulfill()
            }
        })
        .store(in: &subscriptions)

        sut.fetch()

        XCTAssertEqual(statesEmitted[0], .idle)
        XCTAssertEqual(statesEmitted[1], .loading)

        if case let .showingAstronaut(astronautDetailItem) = statesEmitted[2] {
            XCTAssertEqual(astronautDetailItem.id, 12)
            XCTAssertEqual(astronautDetailItem.name, "Alexander Gerst")
            XCTAssertEqual(astronautDetailItem.agencyName, "European Space Agency")
            XCTAssertEqual(astronautDetailItem.formattedDateOfBirth, "03/05/1976")
            XCTAssertEqual(astronautDetailItem.bio.count, 320)
            XCTAssertEqual(
                astronautDetailItem.profileImageURL,
                URL(string: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/astronaut_images/alexander2520gerst_image_20181127211820.jpg")
            )
            XCTAssertEqual(astronautDetailItem.twitterURL, URL(string: "https://twitter.com/Astro_Alex"))
            XCTAssertEqual(astronautDetailItem.instagramURL,URL(string: "https://www.instagram.com/astro_alex_esa/"))
            XCTAssertEqual(astronautDetailItem.wikiURL, URL(string: "https://en.wikipedia.org/wiki/Alexander_Gerst"))
        } else {
            XCTFail()
        }

        waitForExpectations(timeout: 1)
    }

    func testFetchingFailureSequence() {
        let expectation = expectation(description: "Sequence ended")

        let astronautServiceMock = AstronautServiceMock()
        astronautServiceMock.fetchAstronautResult = .failure(.apiError(.invalidStatusCode(statusCode: 500)))
        let sut = AstronautDetailViewModel(astronautId: 12, astronautService: astronautServiceMock)

        var statesEmitted: [AstronautDetailViewModel.State] = []

        sut.$state.sink(receiveValue: { value in
            statesEmitted.append(value)
            if statesEmitted.count == 3 {
                expectation.fulfill()
            }
        })
        .store(in: &subscriptions)

        sut.fetch()

        XCTAssertEqual(statesEmitted[0], .idle)
        XCTAssertEqual(statesEmitted[1], .loading)
        XCTAssertEqual(statesEmitted[2], .error)

        waitForExpectations(timeout: 1)
    }
}

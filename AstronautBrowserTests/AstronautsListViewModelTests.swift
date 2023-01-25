//
//  AstronautsListViewModelTests.swift
//  AstronautBrowserTests
//
//  Created by Ricardo on 24/01/2023.
//

import XCTest
import Combine
@testable import AstronautBrowser

final class AstronautsListViewModelTests: XCTestCase {

    var subscriptions = Set<AnyCancellable>()

    func testIdleState() {
        let astronautServiceMock = AstronautServiceMock()
        astronautServiceMock.fetchAstronautsResult = .success(.mockFirstPage)

        let sut = AstronautsListViewModel(astronautService: astronautServiceMock)
        XCTAssertEqual(sut.state, .idle)
    }

    func testFirstPageSuccessSequence() {
        let expectation = expectation(description: "Sequence ended")

        let astronautServiceMock = AstronautServiceMock()
        astronautServiceMock.fetchAstronautsResult = .success(.mockFirstPage)

        let sut = AstronautsListViewModel(astronautService: astronautServiceMock)

        var statesEmitted: [AstronautsListViewModel.State] = []

        sut.$state.sink(receiveValue: { value in
            statesEmitted.append(value)
            if statesEmitted.count == 3 {
                expectation.fulfill()
            }
        })
        .store(in: &subscriptions)

        sut.fetch()

        XCTAssertEqual(statesEmitted[0], .idle)
        XCTAssertEqual(statesEmitted[1], .loadingFirstPage)
        if case let .showingData(items) = statesEmitted[2] {
            XCTAssertEqual(items.count, 20)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[19].id, 21)
        } else {
            XCTFail()
        }

        waitForExpectations(timeout: 1)
    }

    func testFirstPageFailureSequence() {
        let expectation = expectation(description: "Sequence ended")

        let astronautServiceMock = AstronautServiceMock()
        astronautServiceMock.fetchAstronautsResult = .failure(.apiError(.invalidStatusCode(statusCode: 500)))

        let sut = AstronautsListViewModel(astronautService: astronautServiceMock)

        var statesEmitted: [AstronautsListViewModel.State] = []

        sut.$state.sink(receiveValue: { value in
            statesEmitted.append(value)
            if statesEmitted.count == 3 {
                expectation.fulfill()
            }
        })
        .store(in: &subscriptions)

        sut.fetch()

        XCTAssertEqual(statesEmitted[0], .idle)
        XCTAssertEqual(statesEmitted[1], .loadingFirstPage)
        XCTAssertEqual(statesEmitted[2], .errorLoadingFirstPage)

        waitForExpectations(timeout: 1)
    }

    func testNextPageFailureSequence() {
        let firstPageExpectation = expectation(description: "First page sequence ended")
        let secondPageExpectation = expectation(description: "Second page sequence ended")

        let astronautServiceMock = AstronautServiceMock()
        astronautServiceMock.fetchAstronautsResult = .success(.mockFirstPage)

        let sut = AstronautsListViewModel(astronautService: astronautServiceMock)

        var statesEmitted: [AstronautsListViewModel.State] = []

        sut.$state.sink(receiveValue: { value in
            statesEmitted.append(value)
            if statesEmitted.count == 3 {
                firstPageExpectation.fulfill()
            } else if statesEmitted.count == 5 {
                secondPageExpectation.fulfill()
            }
        })
        .store(in: &subscriptions)

        sut.fetch()

        XCTAssertEqual(statesEmitted.count, 3)
        XCTAssertEqual(statesEmitted[0], .idle)
        XCTAssertEqual(statesEmitted[1], .loadingFirstPage)
        //XCTAssertEqual(statesEmitted[2], .showingData)
        if case let .showingData(items) = statesEmitted[2] {
            XCTAssertEqual(items.count, 20)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[19].id, 21)
        } else {
            XCTFail()
        }

        wait(for: [firstPageExpectation], timeout: 1)

        astronautServiceMock.fetchAstronautsResult = .success(.mockSecondPage)
        sut.fetchNextPage()

        XCTAssertEqual(statesEmitted.count, 5)
        XCTAssertEqual(statesEmitted[0], .idle)
        XCTAssertEqual(statesEmitted[1], .loadingFirstPage)
        if case let .showingData(items) = statesEmitted[2] {
            XCTAssertEqual(items.count, 20)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[19].id, 21)
        } else {
            XCTFail()
        }
        if case let .loadingNextPage(items) = statesEmitted[3] {
            XCTAssertEqual(items.count, 20)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[19].id, 21)
        } else {
            XCTFail()
        }
        if case let .showingData(items) = statesEmitted[4] {
            XCTAssertEqual(items.count, 40)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[19].id, 21)
            XCTAssertEqual(items[20].id, 22)
            XCTAssertEqual(items[39].id, 41)
        } else {
            XCTFail()
        }

        wait(for: [secondPageExpectation], timeout: 1)
    }

    func testNextPageSuccessSequence() {
        let firstPageExpectation = expectation(description: "First page sequence ended")
        let secondPageExpectation = expectation(description: "Second page sequence ended")

        let astronautServiceMock = AstronautServiceMock()
        astronautServiceMock.fetchAstronautsResult = .success(.mockFirstPage)

        let sut = AstronautsListViewModel(astronautService: astronautServiceMock)

        var statesEmitted: [AstronautsListViewModel.State] = []

        sut.$state.sink(receiveValue: { value in
            statesEmitted.append(value)
            if statesEmitted.count == 3 {
                firstPageExpectation.fulfill()
            } else if statesEmitted.count == 5 {
                secondPageExpectation.fulfill()
            }
        })
        .store(in: &subscriptions)

        sut.fetch()

        XCTAssertEqual(statesEmitted.count, 3)
        XCTAssertEqual(statesEmitted[0], .idle)
        XCTAssertEqual(statesEmitted[1], .loadingFirstPage)
        if case let .showingData(items) = statesEmitted[2] {
            XCTAssertEqual(items.count, 20)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[19].id, 21)
        } else {
            XCTFail()
        }

        wait(for: [firstPageExpectation], timeout: 1)

        astronautServiceMock.fetchAstronautsResult = .failure(.apiError(.invalidStatusCode(statusCode: 500)))
        sut.fetchNextPage()

        XCTAssertEqual(statesEmitted.count, 5)
        XCTAssertEqual(statesEmitted[0], .idle)
        XCTAssertEqual(statesEmitted[1], .loadingFirstPage)
        if case let .showingData(items) = statesEmitted[2] {
            XCTAssertEqual(items.count, 20)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[19].id, 21)
        } else {
            XCTFail()
        }
        if case let .loadingNextPage(items) = statesEmitted[3] {
            XCTAssertEqual(items.count, 20)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[19].id, 21)
        } else {
            XCTFail()
        }

        if case let .errorLoadingNextPage(items) = statesEmitted[4] {
            XCTAssertEqual(items.count, 20)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[19].id, 21)
        } else {
            XCTFail()
        }

        wait(for: [secondPageExpectation], timeout: 1)
    }

    func testOpeningDetailScreen() {
        let astronautServiceMock = AstronautServiceMock()
        astronautServiceMock.fetchAstronautsResult = .success(.mockFirstPage)

        let sut = AstronautsListViewModel(astronautService: astronautServiceMock, destination: nil)

        XCTAssertNil(sut.destination)

        sut.showAstronautDetail(id: 123)
        XCTAssertEqual(sut.destination, .detail(id: 123))
    }

    func testOpeningFilteringScreen() {
        let astronautServiceMock = AstronautServiceMock()
        astronautServiceMock.fetchAstronautsResult = .success(.mockFirstPage)

        let sut = AstronautsListViewModel(astronautService: astronautServiceMock, destination: nil)

        XCTAssertNil(sut.destination)

        sut.showFiltering()
        XCTAssertEqual(sut.destination, .filtering(nil))
    }
}

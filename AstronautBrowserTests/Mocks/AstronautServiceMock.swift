//
//  AstronautServiceMock.swift
//  AstronautBrowserTests
//
//  Created by Ricardo on 24/01/2023.
//

import Combine
@testable import AstronautBrowser

final class AstronautServiceMock: AstronautServiceProtocol {

    var fetchAstronautsResult: Result<PaginatedAstronautNormalList, AstronautServiceError>?
    var fetchAstronautResult: Result<AstronautDetail, AstronautServiceError>?

    func fetchAstronauts(
        offset: Int,
        limit: Int,
        filters: [FilterAstronautStatus]?
    ) -> AnyPublisher<PaginatedAstronautNormalList, AstronautServiceError> {
        guard let fetchAstronautsResult = fetchAstronautsResult else {
            fatalError("No mock data available")
        }
        return Result.Publisher(fetchAstronautsResult).eraseToAnyPublisher()
    }

    func fetchAstronaut(id: Int) -> AnyPublisher<AstronautDetail, AstronautServiceError> {
        guard let fetchAstronautResult = fetchAstronautResult else {
            fatalError("No mock data available")
        }
        return Result.Publisher(fetchAstronautResult).eraseToAnyPublisher()
    }
}

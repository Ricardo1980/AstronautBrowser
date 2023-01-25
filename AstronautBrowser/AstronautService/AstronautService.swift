//
//  AstronautService.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation
import Combine

protocol AstronautServiceProtocol {
    func fetchAstronauts(offset: Int, limit: Int, filters: [FilterAstronautStatus]?) -> AnyPublisher<PaginatedAstronautNormalList, AstronautServiceError>
    func fetchAstronaut(id: Int) -> AnyPublisher<AstronautDetail, AstronautServiceError>
}

enum AstronautServiceError: Error {
    case invalidOffset
    case invalidLimit
    case apiError(APIError)
    case unknownError(errorDescription: String)
}

final class AstronautService: AstronautServiceProtocol {

    private let api: APIProtocol
    private let astronautServiceURLFactory: AstronautServiceURLFactory

    init(
        api: APIProtocol = API(),
        astronautServiceURLFactory: AstronautServiceURLFactory = AstronautServiceURLFactory()
    ) {
        self.api = api
        self.astronautServiceURLFactory = astronautServiceURLFactory
    }

    func fetchAstronauts(offset: Int, limit: Int, filters: [FilterAstronautStatus]?) -> AnyPublisher<PaginatedAstronautNormalList, AstronautServiceError> {
        let url: URL
        do {
            url = try astronautServiceURLFactory.makeAstronautsURL(offset: offset, limit: limit, filters: filters)
        } catch let error as AstronautServiceURLError {
            switch error {
            case .invalidOffset:
                return .fail(error: AstronautServiceError.invalidOffset)
            case .invalidLimit:
                return .fail(error: AstronautServiceError.invalidLimit)
            }
        } catch {
            return .fail(error: AstronautServiceError.unknownError(errorDescription: error.localizedDescription))
        }

        return api.get(url: url, decodingType: PaginatedAstronautNormalList.self, queue: .main)
            .mapError {
                AstronautServiceError.apiError($0)
            }
            .eraseToAnyPublisher()
    }

    func fetchAstronaut(id: Int) -> AnyPublisher<AstronautDetail, AstronautServiceError> {
        let url = astronautServiceURLFactory.makeAstronautURL(id: id)
        return api.get(url: url, decodingType: AstronautDetail.self, queue: .main)
            .mapError {
                AstronautServiceError.apiError($0)
            }
            .eraseToAnyPublisher()
    }
}

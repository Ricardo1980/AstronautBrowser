//
//  API.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation
import Combine

protocol APIProtocol {
    func get<T: Decodable>(url: URL, decodingType: T.Type, queue: DispatchQueue) -> AnyPublisher<T, APIError>
}

enum APIError: Error {
    case invalidResponse
    case invalidStatusCode(statusCode: Int)
    case decodingError(description: String)
    case genericError(description: String)
}

final class API: APIProtocol {

    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func get<T: Decodable>(
        url: URL,
        decodingType: T.Type,
        queue: DispatchQueue = .main
    ) -> AnyPublisher<T, APIError> {
        urlSession.dataTaskPublisher(for: url)
            .tryMap {
                guard let httpResponse = $0.response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }

                guard (200..<300) ~= httpResponse.statusCode else {
                    throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
                }

                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError {
                if let error = $0 as? APIError {
                    return error
                } else if let decodingError = $0 as? DecodingError {
                    return APIError.decodingError(description: (decodingError as NSError).localizedDescription)
                }
                // More errors can be managed here like cancelled request or no Internet connection
                return APIError.genericError(description: $0.localizedDescription)
            }
            .receive(on: queue)
            .eraseToAnyPublisher()
    }
}

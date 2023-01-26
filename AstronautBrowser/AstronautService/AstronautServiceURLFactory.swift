//
//  AstronautServiceURLFactory.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation

enum AstronautServiceURLError: Error {
    case invalidOffset
    case invalidLimit
}

struct AstronautServiceURLFactory {

    private let baseURL: URL

    init(baseURL: URL = Constants.baseURL) {
        self.baseURL = baseURL
    }

    func makeAstronautsURL(offset: Int = 0, limit: Int = Constants.defaultPaginationLimit, filters: [FilterAstronautStatus]?) throws -> URL {
        guard offset >= 0 else {
            throw AstronautServiceURLError.invalidOffset
        }

        guard limit > 0, limit < 10000 else {
            throw AstronautServiceURLError.invalidLimit
        }

        var url = baseURL.appending(path: "/astronaut")

        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")

        url.append(queryItems: [offsetQueryItem, limitQueryItem])

        if let filters = filters, !filters.isEmpty {
            let ids = filters.map { String($0.rawValue) }.joined(separator: ",")
            let idsQueryItem = URLQueryItem(name: "status_ids", value: ids)
            url.append(queryItems: [idsQueryItem])
        }

        return url
    }

    func makeAstronautURL(id: Int) -> URL {
        baseURL.appending(path: "/astronaut/\(id)")
    }
}

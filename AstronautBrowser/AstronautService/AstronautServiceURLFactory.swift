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
//
//enum Filter: Int, CustomStringConvertible {
//    case active = 1
//    case retired = 2
//    case inTraining = 3
//    case lostInFlight = 4
//    case lostInTraining = 5
//    case diedWhileInActiveService = 6
//    case dismissed = 7
//    case resignedDuringTraining = 8
//    case deceased = 11
//
//    var description: String {
//        switch self {
//        case .active:
//            return "Active"
//        case .retired:
//            return "Retired"
//        case .inTraining:
//            return "In-Training"
//        case .lostInFlight:
//            return "Lost In Flight"
//        case .lostInTraining:
//            return "Lost In Training"
//        case .diedWhileInActiveService:
//            return "Died While In Active Service"
//        case .dismissed:
//            return "Dismissed"
//        case .resignedDuringTraining:
//            return "Resigned during Training"
//        case .deceased:
//            return "Deceased"
//        }
//    }
//}

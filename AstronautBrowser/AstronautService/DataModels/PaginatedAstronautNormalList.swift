//
//  PaginatedAstronautNormalList.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation

struct PaginatedAstronautNormalList: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [AstronautNormal]
}

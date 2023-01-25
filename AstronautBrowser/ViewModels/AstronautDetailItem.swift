//
//  AstronautDetailItem.swift
//  AstronautBrowser
//
//  Created by Ricardo on 25/01/2023.
//

import Foundation

struct AstronautDetailItem: Equatable {
    let id: Int
    let name: String
    let agencyName: String
    let formattedDateOfBirth: String?
    let bio: String
    let profileImageURL: URL?
    let twitterURL: URL?
    let instagramURL: URL?
    let wikiURL: URL?
}

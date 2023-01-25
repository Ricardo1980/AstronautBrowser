//
//  AstronautNormal.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation

struct AstronautNormal: Decodable {
    let id: Int
    let name: String
    let agency: Agency
    let profileImageThumbnailURL: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case agency
        case profileImageThumbnailURL = "profile_image_thumbnail"
    }
}

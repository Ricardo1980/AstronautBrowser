//
//  AstronautDetail.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation

struct AstronautDetail: Decodable {
    let id: Int
    let name: String
    let agency: Agency
    let dateOfBirth: Date?
    let bio: String
    let profileImageURL: URL?
    let twitterURL: URL?
    let instagramURL: URL?
    let wikiURL: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case agency
        case dateOfBirth = "date_of_birth"
        case bio
        case profileImageURL = "profile_image"
        case twitterURL = "twitter"
        case instagramURL = "instagram"
        case wikiURL = "wiki"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.agency = try container.decode(Agency.self, forKey: .agency)

        // "2023-01-24", year, month and day. It requires special parsing
        if let dateOfBirthString = try container.decodeIfPresent(String.self, forKey: .dateOfBirth) {
            self.dateOfBirth = DateFormatter.parseDOB(dob: dateOfBirthString)
        } else {
            self.dateOfBirth = nil
        }

        self.bio = try container.decode(String.self, forKey: .bio)
        self.profileImageURL = try container.decodeIfPresent(URL.self, forKey: .profileImageURL)
        self.twitterURL = try container.decodeIfPresent(URL.self, forKey: .twitterURL)
        self.instagramURL = try container.decodeIfPresent(URL.self, forKey: .instagramURL)
        self.wikiURL = try container.decodeIfPresent(URL.self, forKey: .wikiURL)
    }
}

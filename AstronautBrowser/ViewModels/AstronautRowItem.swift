//
//  AstronautRowViewModel.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation

struct AstronautRowItem: Identifiable, Equatable {
    let id: Int
    let name: String
    let agencyName: String
    let profileImageThumbnailURL: URL?
}

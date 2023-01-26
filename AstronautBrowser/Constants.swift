//
//  Constants.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation

struct Constants {
    // Here we can use force unwrapping because we know it is always correct.
    // This can also be used inside a Build Configuration so it is easier to create different environments.
    static let baseURL = URL(string: "https://lldev.thespacedevs.com/2.2.0")!
    static let defaultPaginationLimit = 20
}

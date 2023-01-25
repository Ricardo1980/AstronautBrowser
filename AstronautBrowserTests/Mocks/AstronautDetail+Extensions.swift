//
//  AstronautDetail+Extensions.swift
//  AstronautBrowserTests
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation
@testable import AstronautBrowser

extension AstronautDetail {
    static var mock: AstronautDetail {
        final class Dummy {}
        return ResourceLoader.load(
            filename: "astronaut_detail",
            bundle: Bundle(for: Dummy.self)
        )
    }
}

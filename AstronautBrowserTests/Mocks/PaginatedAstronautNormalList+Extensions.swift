//
//  PaginatedAstronautNormalList+Extensions.swift
//  AstronautBrowserTests
//
//  Created by Ricardo on 25/01/2023.
//

import Foundation
@testable import AstronautBrowser

extension PaginatedAstronautNormalList {
    static var mockFirstPage: PaginatedAstronautNormalList {
        final class Dummy {}
        return ResourceLoader.load(
            filename: "paginated_astronaut_normal_list_first_page",
            bundle: Bundle(for: Dummy.self)
        )
    }

    static var mockSecondPage: PaginatedAstronautNormalList {
        final class Dummy {}
        return ResourceLoader.load(
            filename: "paginated_astronaut_normal_list_second_page",
            bundle: Bundle(for: Dummy.self)
        )
    }
}

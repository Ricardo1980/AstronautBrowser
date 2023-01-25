//
//  AnyPublisher+Extensions.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Combine

extension AnyPublisher {
    /// A convenience function on `AnyPublisher` to create a `Fail` without having to include the
    /// boilerplate code to set failure type and erase to `AnyPublisher`.
    ///
    /// - Parameter error: The desired error for the `Fail`.
    /// - Returns: The created `Fail` that has already been erased to `AnyPublisher`.
    static func fail(error: Failure) -> Self {
        Fail(error: error).eraseToAnyPublisher()
    }
}

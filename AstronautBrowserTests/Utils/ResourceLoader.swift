//
//  ResourceLoader.swift
//  AstronautBrowserTests
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation

struct ResourceLoader {

    static func load<T: Decodable>(filename: String, bundle: Bundle = Bundle.main) -> T {

        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("File not found")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Cannot load data")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Cannot parse: \(error.localizedDescription)")
        }
    }
}

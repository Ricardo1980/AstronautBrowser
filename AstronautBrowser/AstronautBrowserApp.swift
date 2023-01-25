//
//  AstronautBrowserApp.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import SwiftUI

@main
struct AstronautBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            AstronautsListView(
                viewModel: AstronautsListViewModel()
            )
        }
    }
}

//
//  ErrorLoadingNextPageRowView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 25/01/2023.
//

import SwiftUI

struct ErrorLoadingNextPageRowView: View {

    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)

            Text("Error loading next page")
                .font(.subheadline)

            Button("Retry") {
                action()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

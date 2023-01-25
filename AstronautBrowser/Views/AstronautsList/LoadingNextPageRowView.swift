//
//  LoadingNextPageRowView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 25/01/2023.
//

import SwiftUI

struct LoadingNextPageRowView: View {

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "paperplane.fill")
                .foregroundColor(.red)

            Text("Loading next page...")
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

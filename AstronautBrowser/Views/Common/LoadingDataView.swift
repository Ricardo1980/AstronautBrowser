//
//  LoadingView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import SwiftUI

struct LoadingDataView: View {

    let message: String = "Loading..."

    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .center, spacing: 12) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 50.0))
                    .foregroundColor(.red)
                Text(message)
                    .font(.subheadline)
            }
        }
        .ignoresSafeArea()
    }
}

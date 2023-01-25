//
//  ErrorView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import SwiftUI

struct ErrorLoadingDataView: View {

    let action: () -> Void

    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .center, spacing: 12) {
                Text("There was an error\nPress Retry to try again")
                    .font(.subheadline)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)

                Image(systemName: "xmark.octagon.fill")
                    .font(.system(size: 50.0))
                    .foregroundColor(.red)

                Button("Retry") {
                    action()
                }
                .font(.subheadline)
            }
        }
        .ignoresSafeArea()
    }
}

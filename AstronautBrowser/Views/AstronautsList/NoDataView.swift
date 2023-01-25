//
//  NoDataView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 25/01/2023.
//

import SwiftUI

struct NoDataView: View {

    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 16) {
                Image(systemName: "doc")
                    .font(.system(size: 50.0))
                    .foregroundColor(.red)
                Text("No data retrieved, try different filters")
                    .font(.subheadline)
            }
        }
        .ignoresSafeArea()
    }
}

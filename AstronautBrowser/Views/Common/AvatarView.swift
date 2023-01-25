//
//  AvatarView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import SwiftUI

// The reason the image is scaled to fill is to avoid empty spaces at both sides.
// In the same way, it is aligned to the top, because usually the astronaut's head is at the top or the middle of the canvas.
// Otherwise (center alignment), the head would be cut in some cases.
struct AvatarView: View {

    enum Size {
        case small
        case medium
    }

    let url: URL
    let size: Size

    var body: some View {
        AsyncImage(
            url: url,
            transaction: Transaction(animation: .easeInOut)
        ) { phase in
            switch phase {
            case .empty:
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity)
            case .failure:
                VStack {
                    Spacer()
                    Image(systemName: "wifi.slash")
                    Spacer()
                }
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: frameSize.width, height: frameSize.height, alignment: .top)
        .background(Color(.systemGray6))
        .clipShape(Circle())
    }

    private var frameSize: CGSize {
        switch size {
        case .small:
            return CGSize(width: 60, height: 60)
        case .medium:
            return CGSize(width: 200, height: 200)
        }
    }
}

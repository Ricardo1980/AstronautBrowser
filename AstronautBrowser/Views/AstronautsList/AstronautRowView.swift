//
//  AstronautRowView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import SwiftUI

struct AstronautRowView: View {

    let item: AstronautRowItem

    var body: some View {
        HStack(spacing: 16) {
            if let profileImageThumbnailURL = item.profileImageThumbnailURL {
                AvatarView(url: profileImageThumbnailURL, size: .small)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.headline)
                Text(item.agencyName)
                    .font(.subheadline)
            }

            Spacer()
        }
        .padding()
    }
}

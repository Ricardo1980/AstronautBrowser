//
//  AstronautDetailView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import SwiftUI


struct AstronautDetailView: View {
    
    @StateObject var viewModel: AstronautDetailViewModel

    // https://stackoverflow.com/a/62636048/917338
    init(astronautId: Int) {
        self._viewModel = StateObject(wrappedValue: AstronautDetailViewModel(astronautId: astronautId))
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingDataView()
            case .error:
                ErrorLoadingDataView() {
                    viewModel.fetch()
                }
            case .showingAstronaut(let astronautDetailItem):
                astronautView(item: astronautDetailItem)
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }

    private func astronautView(item: AstronautDetailItem) -> some View {
        VStack(spacing: 12) {
            if let profileImageURL = item.profileImageURL {
                AvatarView(url: profileImageURL, size: .medium)
            }

            Text(item.name)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .font(.largeTitle)

            Text(item.agencyName)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .font(.headline)

            if let formattedDateOfBirth = item.formattedDateOfBirth {
                Text("Date of birth: \(formattedDateOfBirth)")
                    .font(.subheadline)
            }

            HStack(spacing: 16) {
                if let twitterURL = item.twitterURL {
                    Link("\(Image(systemName: "bird.fill")) Twitter", destination: twitterURL)
                }
                if let instagramURL = item.instagramURL {
                    Link("\(Image(systemName: "camera")) Instagram", destination: instagramURL)
                }
                if let wikiURL = item.wikiURL {
                    Link("\(Image(systemName: "globe")) Wiki", destination: wikiURL)
                }
            }
            .font(.subheadline)
            .foregroundColor(.blue)

            ScrollView {
                Text(item.bio)
            }
            .font(.body)

            Spacer()
        }
    }
}

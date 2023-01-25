//
//  AstronautDetailViewModel.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation
import Combine

final class AstronautDetailViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case error
        case showingAstronaut(AstronautDetailItem)
    }

    @Published var state = State.idle

    private let astronautId: Int
    private let astronautService: AstronautServiceProtocol
    var subscriptions = Set<AnyCancellable>()

    init(astronautId: Int, astronautService: AstronautServiceProtocol = AstronautService()) {
        self.astronautId = astronautId
        self.astronautService = astronautService
    }

    func fetch() {
        astronautService.fetchAstronaut(id: astronautId)
            .map { astronautDetail -> State in
                let formattedDateOfBirth = astronautDetail.dateOfBirth.map {
                    DateFormatter.localizedString(from: $0, dateStyle: .short, timeStyle: .none)
                }
                let astronautDetailItem = AstronautDetailItem(
                    id: astronautDetail.id,
                    name: astronautDetail.name,
                    agencyName: astronautDetail.agency.name,
                    formattedDateOfBirth: formattedDateOfBirth,
                    bio: astronautDetail.bio,
                    profileImageURL: astronautDetail.profileImageURL,
                    twitterURL: astronautDetail.twitterURL,
                    instagramURL: astronautDetail.instagramURL,
                    wikiURL: astronautDetail.wikiURL
                )
                return .showingAstronaut(astronautDetailItem)
            }
            .catch { _ in
                Just(State.error)
            }
            .prepend(.loading)
            .eraseToAnyPublisher()
            .assign(to: &$state)
    }
}

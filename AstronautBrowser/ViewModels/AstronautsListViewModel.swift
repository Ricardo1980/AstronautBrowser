//
//  AstronautsListViewModel.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Combine

final class AstronautsListViewModel: ObservableObject {

    // From the main screen, we can go to 2 different screens.
    // Astronaut detail screen, pushing the screen using a navigation stack
    // Filtering screen, showing it modally
    enum Destination: Equatable {
        case filtering([FilterAstronautStatus]?)
        case detail(id: Int)
    }

    enum State: Equatable {
        case idle
        case loadingFirstPage
        case errorLoadingFirstPage
        case showingData([AstronautRowItem])
        case loadingNextPage([AstronautRowItem])
        case errorLoadingNextPage([AstronautRowItem])
    }

    @Published var state = State.idle
    @Published var destination: Destination?

    private var totalRemoteNumberOfAstronauts = 0
    private var astronautRowItems: [AstronautRowItem] = []
    private(set) var filters: [FilterAstronautStatus]?
    private var subscriptions = Set<AnyCancellable>()

    private let astronautService: AstronautServiceProtocol

    init(astronautService: AstronautServiceProtocol = AstronautService(), destination: Destination? = nil) {
        self.astronautService = astronautService
        self.destination = destination
    }

    func fetch() {
        astronautRowItems = []
        fetch(offset: 0)
    }

    func fetchNextPage() {
        // To calculate the next offset, just check how many elements are we presenting right now.
        // If we are not presenting elements, then we should not fetch the next page.
        let offset: Int
        switch state {
        case .showingData(let elements), .loadingNextPage(let elements), .errorLoadingNextPage(let elements):
            offset = elements.count
        default:
            return
        }

        // If offset is equal (or greater) than the total number of elements in the server (with or without filter),
        // there is no point sending this request
        guard offset < totalRemoteNumberOfAstronauts else {
            return
        }

        fetch(offset: offset)
    }

    private func fetch(offset: Int) {
        state = astronautRowItems.count == 0 ? .loadingFirstPage : .loadingNextPage(astronautRowItems)

        astronautService.fetchAstronauts(offset: offset, limit: Constants.defaultPaginationLimit, filters: filters)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    print("Error fetching data: \(error.localizedDescription)")
                    self.state = self.astronautRowItems.count == 0 ? .errorLoadingFirstPage : .errorLoadingNextPage(self.astronautRowItems)
                }
            } receiveValue: { [weak self] paginatedAstronautNormalList in
                guard let self = self else { return }
                self.totalRemoteNumberOfAstronauts = paginatedAstronautNormalList.count

                let astronautRowItems = paginatedAstronautNormalList.results.map { astronautNormal -> AstronautRowItem in
                    AstronautRowItem(
                        id: astronautNormal.id,
                        name: astronautNormal.name,
                        agencyName: astronautNormal.agency.name,
                        profileImageThumbnailURL: astronautNormal.profileImageThumbnailURL
                    )
                }

                self.astronautRowItems = self.astronautRowItems + astronautRowItems
                self.state = .showingData(self.astronautRowItems)
            }
            .store(in: &subscriptions)
    }

    func showAstronautDetail(id: Int) {
        destination = .detail(id: id)
    }

    func dismissAstronautDetail() {
        destination = nil
    }

    func showFiltering() {
        destination = .filtering(filters)
    }

    func dismissFiltering() {
        destination = nil
    }

    func applyFiltering(filters: [FilterAstronautStatus]?) {
        destination = nil
        self.filters = filters
        astronautRowItems = []
        fetch(offset: 0)
    }
}

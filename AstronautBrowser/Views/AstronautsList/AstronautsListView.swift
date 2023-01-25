//
//  AstronautsListView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import SwiftUI
import SwiftUINavigation

struct AstronautsListView: View {

    private enum RowItem: Identifiable {
        case astronaut(AstronautRowItem)
        case loading
        case error

        var id: Int {
            switch self {
            case let .astronaut(astronautRowItem):
                return astronautRowItem.id
            case .loading:
                return -1
            case .error:
                return -2
            }
        }
    }

    //@StateObject var viewModel = AstronautsListViewModel()
    @ObservedObject var viewModel: AstronautsListViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                List(rowItems) { rowItem in
                    switch rowItem {
                    case let .astronaut(astronautRowItem):

                        Button {
                            self.viewModel.showAstronautDetail(id: astronautRowItem.id)
                        } label: {
                            AstronautRowView(item: astronautRowItem)
                        }
                        .listRowInsets(EdgeInsets())
                        .onAppear {
                            if astronautRowItem.id == astronautRowItems.last?.id {
                                viewModel.fetchNextPage()
                            }
                        }


                    case .loading:
                        LoadingNextPageRowView()
                            .listRowInsets(EdgeInsets())

                    case .error:
                        ErrorLoadingNextPageRowView() {
                            viewModel.fetchNextPage()
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.plain)

                if case .loadingFirstPage = viewModel.state {
                    LoadingDataView()
                }

                if case .errorLoadingFirstPage = viewModel.state {
                    ErrorLoadingDataView() {
                        viewModel.fetch()
                    }
                }

                if case let .showingData(items) = viewModel.state, items.isEmpty {
                    NoDataView()
                }
            }
            .toolbar {
                Button {
                    viewModel.showFiltering()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
            .navigationTitle("Astronauts")
            .navigationDestination(unwrapping: $viewModel.destination, case: /AstronautsListViewModel.Destination.detail) { $id in
                AstronautDetailView(astronautId: id)
                    .navigationTitle("Astronaut")
            }
        }
        .onAppear {
            viewModel.fetch()
        }
        .sheet(unwrapping: $viewModel.destination, case: /AstronautsListViewModel.Destination.filtering) { $filters in
            NavigationView {
                FilteringView(filters: $filters)
                    .navigationBarTitle("Filtering")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                self.viewModel.dismissFiltering()
                            }
                        }
                        ToolbarItem(placement: .primaryAction) {
                            Button("Apply") {
                                self.viewModel.applyFiltering(filters: filters)
                            }
                        }
                    }
            }
        }
    }

    // General purpose items that, apart from astronaut items, can also contain the
    // "loading next page cell" or "error loading next page cell" at the bottom.
    private var rowItems: [RowItem] {
        switch viewModel.state {
        case .showingData(let items):
            return items.map { astronautItem -> RowItem in
                .astronaut(astronautItem)
            }

        case .loadingNextPage(let items):
            return items.map { astronautItem -> RowItem in
                .astronaut(astronautItem)
            } + [.loading]

        case .errorLoadingNextPage(let items):
            return items.map { astronautItem -> RowItem in
                .astronaut(astronautItem)
            } + [.error]

        default:
            return []
        }
    }

    // Only astronaut items
    private var astronautRowItems: [AstronautRowItem] {
        switch viewModel.state {
        case .showingData(let items), .loadingNextPage(let items), .errorLoadingNextPage(let items):
            return items
        default:
            return []
        }
    }
}

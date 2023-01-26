//
//  FilteringView.swift
//  AstronautBrowser
//
//  Created by Ricardo on 25/01/2023.
//

import SwiftUI

struct FilteringView: View {

    @Binding var filters: [FilterAstronautStatus]?

    var body: some View {
        VStack {
            Text("All astronaut statuses")

            List(FilterAstronautStatus.allCases) { filterAstronautStatusCase in
                Toggle(filterAstronautStatusCase.description, isOn: Binding<Bool>(get: {
                    // Returns if the filter is inside the array or not.
                    // If it is inside the collection, we consider that the filter is active
                    filters?.contains(filterAstronautStatusCase) ?? false

                }, set: { value, _ in
                    // If value is false, then we have to remove this filter from the collection
                    // If true, then we have to add it (if the collection is empty, we have to create it)
                    filters = filters?.filter { $0 != filterAstronautStatusCase }
                    if value {
                        if let filters = filters {
                            self.filters = filters + [filterAstronautStatusCase]
                        } else {
                            filters = [filterAstronautStatusCase]
                        }
                    }
                }))
            }
        }
    }
}


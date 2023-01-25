//
//  FilterAstronautStatus.swift
//  AstronautBrowser
//
//  Created by Ricardo on 25/01/2023.
//

import Foundation

enum FilterAstronautStatus: Int, CaseIterable, CustomStringConvertible, Identifiable, Equatable {
    case active = 1
    case retired = 2
    case inTraining = 3
    case lostInFlight = 4
    case lostInTraining = 5
    case diedWhileInActiveService = 6
    case dismissed = 7
    case resignedDuringTraining = 8
    case deceased = 11

    var description: String {
        switch self {
        case .active:
            return "Active"
        case .retired:
            return "Retired"
        case .inTraining:
            return "In-Training"
        case .lostInFlight:
            return "Lost In Flight"
        case .lostInTraining:
            return "Lost In Training"
        case .diedWhileInActiveService:
            return "Died While In Active Service"
        case .dismissed:
            return "Dismissed"
        case .resignedDuringTraining:
            return "Resigned during Training"
        case .deceased:
            return "Deceased"
        }
    }

    var id: Int {
        rawValue
    }
}

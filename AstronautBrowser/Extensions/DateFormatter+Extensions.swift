//
//  DateFormatter+Extensions.swift
//  AstronautBrowser
//
//  Created by Ricardo on 24/01/2023.
//

import Foundation

// To manage the DOB received from the server, which uses a specific format (year, month, day).
// Given that there are other formats in the web service, it is better to that like this rather than at the JSONDecoder level.
extension DateFormatter {

    private static var dobFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func parseDOB(dob: String) -> Date? {
        dobFormatter.date(from: dob)
    }
}

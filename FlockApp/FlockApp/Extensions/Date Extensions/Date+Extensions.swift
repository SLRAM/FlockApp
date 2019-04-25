//
//  Date+Extensions.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/8/19.
//

import Foundation

extension Date {
    // get an ISO timestamp
    static func getISOTimestamp() -> String { // Date.getISOTimestamp()
        let isoDateFormatter = ISO8601DateFormatter()
        let timestamp = isoDateFormatter.string(from: Date())
        return timestamp
    }
    
    func toString( dateFormat format  : String ) -> String // let date, date.toString("")
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
}

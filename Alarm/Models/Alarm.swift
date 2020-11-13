//
//  Alarm.swift
//  Alarm
//
//  Created by Heli Bavishi on 11/9/20.
//

import Foundation

class Alarm: Codable {
    var name: String
    var enabled: Bool
    let uuid: String
    var fireDate: Date
    var fireTimeAsString: String {
        
        let dateFormateer = DateFormatter()
        dateFormateer.dateStyle = .none
        dateFormateer.timeStyle = .short
        let dateString = (dateFormateer.string(from: self.fireDate))
        return dateString
    }
    
    init(name: String, enabled: Bool, uuid: String = UUID().uuidString, fireDate: Date) {
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
        self.fireDate = fireDate
    }
}// END of class

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        lhs.enabled == rhs.enabled &&
        lhs.fireDate == rhs.fireDate &&
        lhs.name == rhs.name
        
    }
}

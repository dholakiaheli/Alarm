//
//  AlarmController.swift
//  Alarm
//
//  Created by Heli Bavishi on 11/9/20.
//

import UIKit
protocol AlarmScheduler: AnyObject {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

class AlarmController {
        
   static let shared  =  AlarmController()
    
    var alarms: [Alarm] = []
    //create delegate variable
    weak var delegate: AlarmScheduler?
    
    //Mock data
//     let mockAlarms: [Alarm] = {
//        var mockData = Alarm(name: "Alarm1", enabled: true, fireDate: Date())
//        return [mockData]
//    }()
//    
//    init() {
//        self.alarms = mockAlarms
//    }
    
    //create
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let alarm = Alarm(name: name, enabled: enabled, fireDate: fireDate)
        alarms.append(alarm)
        if enabled {
            scheduleUserNotifications(for: alarm)
        }
        saveToPersistance()
    }

    //delete
    func deleteAlarm(alarm: Alarm) {
        guard let index = alarms.firstIndex(of: alarm) else { return }
        cancelUserNotifications(for: alarm)
        alarms.remove(at: index)
        saveToPersistance()
    }
    
    //update
    func update(alarm:Alarm, fireDate: Date,name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        alarm.name = name
        if enabled {
            scheduleUserNotifications(for: alarm)
        }
        saveToPersistance()
    }
   
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled.toggle()
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        }else {
            cancelUserNotifications(for: alarm)
        }
    }
    
    //MARK: - Persistance
    //Persistance our data
    
    /// creating a function that returns a url path where our info will be stored
    func createFileForPersistence() -> URL {
        ///creating property called url by accessing documentDirectory in or file manager
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        /// declaring a constant called fileURL and appending the name of our file to create our full file path
        let fileURL = url[0].appendingPathComponent("alarm.json")
        return fileURL
    }
    
    //
    func saveToPersistance() {
        /// creating an instant of JSONEncoder initized and naming it jsonEncdoer
        let jsonEncoder = JSONEncoder()
        do {
            let jsonAlarm = try jsonEncoder.encode(alarms)
            try jsonAlarm.write(to: createFileForPersistence())
        } catch let encodingError {
            /// handing our potential encoding error with a simple print statement
            print("There was an error encoing the data \(encodingError.localizedDescription)")
        }
    }
    
    //
    func loadFromPersistance() {
        /// creating an instant of JSONDecoder initized and naming it jsonDecoder

        let jsonDecoder = JSONDecoder()
        do {
            let decodedAlarm = try Data(contentsOf: createFileForPersistence())
            alarms = try jsonDecoder.decode([Alarm].self, from: decodedAlarm)
        } catch let decodingError {
            /// handing our potential decoding error with a simple print statement
            print("There was an error decoding data \(decodingError.localizedDescription)")
        }
    }
}

extension AlarmController: AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm Schedule!"
        content.subtitle = "It is time to get going!"
        content.badge = 1
        content.sound = UNNotificationSound.default

        let date = Calendar.current.dateComponents([.day, .hour, .minute], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
            } else {
                print("User will get a local notification on \(alarm.fireDate)")
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
          let identifiers: [String] = {
              let identifier = alarm.uuid
              return[identifier]
          }()
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
      } 
}

//
//  AppSettings.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import Foundation
import UserNotifications

enum AppSettings {
    @UserDefaultWrapper(key: UserDefaultKeyConstants.noteDisplayTypeSelected, defaultValue: "")
    // noteDisplayTypeSelected Property Wrapper
    static var noteDisplayTypeSelected: String
    
    @UserDefaultWrapper(key: UserDefaultKeyConstants.noteSortType, defaultValue: "")
    // noteSortType Property Wrapper
    static var noteSortType: String
    
    static func removeNotification(noteObj: NoteObj) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [noteObj.id])
    }
    
    static func createNotification(noteObj: NoteObj) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [noteObj.id])
        
        let content = UNMutableNotificationContent()
        content.title = noteObj.noteName
        content.body = noteObj.noteText
        content.sound = UNNotificationSound.default
        content.userInfo = ["id": noteObj.id]

        // show this notification

        var triggerDateComponents: DateComponents!
        
        switch noteObj.repeatType {
        case .never:
            return
        case .justOneTime:
            triggerDateComponents = Calendar.current.dateComponents([.hour, .minute, .second],
                                                                    from: noteObj.reminderDate)
        case .always: // Daily
            triggerDateComponents = Calendar.current.dateComponents([.hour, .minute, .second],
                                                                    from: noteObj.reminderDate)
        case .weekly: // Weekly
            triggerDateComponents = Calendar.current.dateComponents([.timeZone, .weekday, .hour, .minute, .second],
                                                                    from: noteObj.reminderDate)
        case .monthly: // Monthly
            triggerDateComponents = Calendar.current.dateComponents([.timeZone, .weekOfMonth, .weekday, .hour, .minute, .second],
                                                                    from: noteObj.reminderDate)
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents,
                                                    repeats: noteObj.repeatType == .justOneTime ? false : true)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: noteObj.id, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}

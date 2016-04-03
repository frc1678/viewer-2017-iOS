//
//  CurrentMatchManager.swift
//  Pods
//
//  Created by Samuel Resendez on 4/3/16.
//
//

import UIKit
import Haneke

class CurrentMatchManager: NSObject {
    
    let notificationManager : NotificationManager
    let cache = Shared.dataCache
    var initCounter = 0
    
    
    
    override init() {
        
        self.notificationManager = NotificationManager(secsBetweenUpdates: 5, notifications: [])
        super.init()
        
        self.notificationManager.notifications.append(NotificationManager.Notification(name: "currentMatchUpdated", selector: "notificationTriggeredCheckForNotification:", object: nil))
        self.setUpHank()
    }
    
    func setUpHank() {
        cache.fetch(key: "starredMatches").onSuccess { (d) -> () in
            if let starred = NSKeyedUnarchiver.unarchiveObjectWithData(d) as? [String] {
                if self.starredMatchesArray != starred {
                    self.starredMatchesArray = starred
                }
            } else {
                self.starredMatchesArray = [String]()
            }
        }

    }
    
    var currentMatch = 0 {
        didSet {
            print("currentMatch changed!")
            if currentMatch != oldValue {
                NSNotificationCenter.defaultCenter().postNotificationName("currentMatchUpdated", object: nil)
                notifyIfNeeded()
            }
          
        }
    }
    var starredMatchesArray = [String]() {
        didSet {
            cache.set(value: NSKeyedArchiver.archivedDataWithRootObject(starredMatchesArray ?? NSMutableArray()), key: "starredMatches")
        }
    }
    
    func notifyIfNeeded() {
        print("notifyIfNeeded called")
        print(currentMatch)
        print(starredMatchesArray)
        if starredMatchesArray.contains(String(currentMatch)) {
            postNotification("Starred match coming up: " + String(currentMatch))
        }
        if starredMatchesArray.contains(String(currentMatch + 1)) {
            postNotification("Starred match coming up: " + String(currentMatch + 1 ))
        }
        if starredMatchesArray.contains(String(currentMatch + 2)) {
            postNotification("Starred match coming up: " + String(currentMatch + 2))
        }

    }
    
    func postNotification(notificationBody:String) {
            let localNotification = UILocalNotification()
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
            localNotification.alertBody = notificationBody
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
     
        
    }

    func notificationTriggeredCheckForNotification(note:NSNotification) {
        notifyIfNeeded()
    }
    

}

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
    
    override init() {
        self.notificationManager = NotificationManager(secsBetweenUpdates: 5, notifications: [])
        super.init()
        self.notificationManager.notifications.append(NotificationManager.Notification(name: "currentMatchUpdated", selector: "notificationTriggeredCheckForNotification:", object: nil))
        self.setUp()
    }
    
    func setUp() {
        cache.fetch(key: "starredMatches").onSuccess { (d) -> () in
            if let starred = NSKeyedUnarchiver.unarchiveObject(with: d) as? [String] {
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
            if currentMatch != oldValue {
                let currentMatchFetch = AppDelegate.getAppDelegate().firebaseFetcher.getMatch(currentMatch)
                let m : [String: AnyObject] = ["num":currentMatch as AnyObject, "redTeams": currentMatchFetch.redAllianceTeamNumbers! as AnyObject, "blueTeams": currentMatchFetch.blueAllianceTeamNumbers! as AnyObject]
                UserDefaults.standard.set(m, forKey: "match")
                notifyIfNeeded()
            }
        }
    }
    
    var starredMatchesArray = [String]() {
        didSet {
            cache.set(value: NSKeyedArchiver.archivedData(withRootObject: starredMatchesArray), key: "starredMatches")
        }
    }
    
    func notifyIfNeeded() {
        let notifyForNumMatchesAway = 2
        
        for n in 0..<notifyForNumMatchesAway {
            if starredMatchesArray.contains(String(currentMatch + n)) {
                postNotification("Starred match coming up: " + String(currentMatch + n))
            }
        }
    }
    
    func postNotification(_ notificationBody: String) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date(timeIntervalSinceNow: 1)
        localNotification.alertBody = notificationBody
        localNotification.timeZone = TimeZone.current
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    func notificationTriggeredCheckForNotification(_ note: Notification) {
        notifyIfNeeded()
    }
}

//
//  CurrentMatchManager.swift
//  Pods
//
//  Created by Samuel Resendez on 4/3/16.
//
//

//NOTE: Is not currently being used as of 2017.

import UIKit
import Haneke
import UserNotifications
import Firebase

class CurrentMatchManager: NSObject {
    
    let notificationManager : NotificationManager
    let cache = Shared.dataCache
    let firebase: FIRDatabaseReference
    
    override init() {
        firebase = FIRDatabase.database().reference()
        
        self.notificationManager = NotificationManager(secsBetweenUpdates: 5, notifications: [])
        super.init()
        self.notificationManager.notifications.append(NotificationManager.Notification(name: "currentMatchUpdated", selector: "notificationTriggeredCheckForNotification:", object: nil))
        
        firebase.child("currentMatchNum").observeSingleEvent(of: .value, with: { (snap) -> Void in
            self.currentMatch = snap.value as! Int
        })

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
            if currentMatch != oldValue && currentMatch != -1 {
                if let currentMatchFetch = AppDelegate.getAppDelegate().firebaseFetcher.getMatch(currentMatch) {
                    let m : [String: AnyObject] = ["num":currentMatch as AnyObject, "redTeams": currentMatchFetch.redAllianceTeamNumbers! as AnyObject, "blueTeams": currentMatchFetch.blueAllianceTeamNumbers! as AnyObject]
                    UserDefaults.standard.set(m, forKey: "match")
                    notifyIfNeeded()
                }
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
    
    func postNotification(_ notificationBody:String) {
        let content = UNMutableNotificationContent()
        content.body = notificationBody
        content.sound = UNNotificationSound.default()
        content.badge = NSNumber(integerLiteral: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.title = "Upcoming Starred Match"
        let localNotification = UNNotificationRequest(identifier: "ViewerNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(localNotification, withCompletionHandler: nil)
    }
    
    func notificationTriggeredCheckForNotification(_ note: Notification) {
        notifyIfNeeded()
    }
}

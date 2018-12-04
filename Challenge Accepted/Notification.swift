//
//  Notification.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-11-30.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import Foundation
import UserNotifications


class Notification: UNUserNotificationCenter{
    
}
//Get the Notification center
let center = UNUserNotificationCenter.current()

//Create the content for the notification
func Content() -> UNMutableNotificationContent{
    let content = UNMutableNotificationContent()
    content.title = "Bye Bye"
    content.body = "Have a good day!"
    content.sound = UNNotificationSound.default
    return content
}

//Notification trigger
func Trigger() -> UNTimeIntervalNotificationTrigger{
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
    return trigger
}

//Notification Request
func Request() -> UNNotificationRequest {
    let request = UNNotificationRequest(identifier: "ContentIdentifier", content: Content(), trigger: Trigger())
    return request
}


//Add a Notification
func AddNotification(){
    center.add(Request()){ (error) in
        if error != nil{
            print("error \(String(describing: error))")
        }
    }
    print("Notification")
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping() -> Void){
        completionHandler()
    }
}

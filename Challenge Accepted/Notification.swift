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
    content.title = "New Challenge recieved"
    content.body = "A new Challenge can be found in your inbox."
    content.sound = UNNotificationSound.default
    return content
}

//Notification trigger
func Trigger() -> UNTimeIntervalNotificationTrigger{
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
    return trigger
}

//Notification Request
func Request() -> UNNotificationRequest {
    let request = UNNotificationRequest(identifier: "ContentIdentifier", content: Content(), trigger: Trigger())
    return request
}


//Add a Notification
func addNotification(){
    center.add(Request()){ (error) in
        if error != nil{
            print("error \(String(describing: error))")
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping() -> Void){
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
                                
}

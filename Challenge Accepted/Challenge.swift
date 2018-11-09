//
//  Challenge.swift
//  Challenge Accepted
//
//  Created by Jacob Carlquist on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import Foundation
import UIKit

class Challenge {
    
    var creator: User
    var title: String
    var description: String
    var state: Status
    var imageState: UIImage
    //var media: UIImage
    enum Status{
        case done
        case accepted
        case denied
        case unread
        case pending
    }
    
    init(title: String, description: String, creator: User, imageState: UIImage/*, media: UIImage*/){
        self.creator = creator
        self.title = title
        self.description = description
        self.state = Status.unread
        self.imageState = imageState
        //self.media = media
        
    }
    
    
    func getChallenge() -> Challenge{
        return self
    }
    
    func setStatus(status: Status){
        switch status {
        case .done:
            self.state = Status.done
            self.imageState = UIImage(named: "done")!
        case .accepted:
            self.state = Status.accepted
            self.imageState = UIImage(named: "accepted")!
        case .denied:
            self.state = Status.denied
            self.imageState = UIImage(named: "denied")!
        case .pending:
            self.state = Status.pending
            self.imageState = UIImage(named: "pending")!
        case .unread:
            self.state = Status.unread
            self.imageState = UIImage(named: "unread")!
        }
    }
    func setTitle(title: String){
        self.title = title
    }
    func setDescription(description: String){
        self.description = description
    }
    
    func getTitel() -> String {
        return self.title
    }
    func getDescription() -> String {
        return self.description
    }
    func getStatus() -> Status {
        return self.state
    }
    func getStatusImage() -> UIImage {
        return self.imageState
    }
    
}

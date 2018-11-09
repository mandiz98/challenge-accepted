//
//  Challenge.swift
//  Challenge Accepted
//
//  Created by Jacob Carlquist on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import Foundation

class Challenge {
    
    init(title: String, description: String, creator: User){
        self.creator = creator
        self.title = title
        self.description = description
        self.state = Status.unread
        
    }
    
    
    func getChallenge() -> Challenge{
        return self
    }
    
    func setStatus(status: Status){
        switch status {
        case .done:
            self.state = Status.done
        case .accepted:
            self.state = Status.accepted
        case .denied:
            self.state = Status.denied
        case .pending:
            self.state = Status.pending
        case .unread:
            self.state = Status.unread
            
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
    
    var creator: User
    var title: String
    var description: String
    var state: Status
    enum Status{
        case done
        case accepted
        case denied
        case unread
        case pending
    }
}

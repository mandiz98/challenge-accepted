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
    //MARK: variables
    var creator: String
    var title: String
    var description: String
    var state: Status
    var imageState: UIImage
    var proof: String
    //MARK: Status enum
    enum Status: String{
        case accepted = "accepted"
        case denied = "denied"
        case unread = "unread"
        case pending = "pending"
    }
    
    //MARK: Functions
    //Initializer
    init(title: String, description: String, creator: String, imageState: UIImage, state: Status, proof: String){
        self.creator = creator
        self.title = title
        self.description = description
        self.imageState = imageState
        self.state = state
        self.proof = proof
    }
    
    //MARK: Setters
    func setStatus(status: Status){
        switch status {
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
    
    //MARK: Getters
    func getChallenge() -> Challenge{
        return self
    }
    func getCreator()->String{
        return self.creator
    }
    func getTitel() -> String {
        return self.title
    }
    func getDescription() -> String {
        return self.description
    }
    func getStatus() -> String {
        return self.state.rawValue
    }
    func getStatusImage() -> UIImage {
        return self.imageState
    }
}



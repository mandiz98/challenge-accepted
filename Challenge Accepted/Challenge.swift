//
//  Challenge.swift
//  Challenge Accepted
//
//  Created by Jacob Carlquist on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import Foundation

class Challenge {
    
    init(titel: String, description: String, status: String){
        self.titel = titel
        self.description = description
        self.status = status
    }
    
    
    func setStatus(status: String){
        self.status = status
    }
    
    func getTitel() -> String {
        return self.titel
    }
    func getDescription() -> String {
        return self.description
    }
    func getStatus() -> String {
        return self.status
    }
    
    
    var titel: String
    var description: String
    var status: String
}

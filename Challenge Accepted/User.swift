//
//  User.swift
//  Challenge Accepted
//
//  Created by Jacob Carlquist on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import Foundation

class User {
    
    
    var name: String
    var points: Int
    var challenges: [Challenge]
    
    init(name: String, points: Int) {
        self.name = name
        self.points = points
        self.challenges = []
    }
    
    func setName(name: String){
        self.name = name
    }
    
    func setPoints(points: Int){
        self.points = points
    }
    
    func addChallenge(challenge: Challenge){
        self.challenges.append(challenge)
    }
    
    func getName()-> String{
        return self.name
    }
    func getPoints() -> Int{
        return self.points
    }
    
    func getAllChallenges() -> [Challenge]{
        return self.challenges
    }
}

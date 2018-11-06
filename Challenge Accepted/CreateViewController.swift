//
//  CreateViewController.swift
//  Challenge Accepted
//
//  Created by Jacob Carlquist on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet weak var challengeTitle: UITextField!
    @IBOutlet weak var challengeDescription: UITextView!
    @IBOutlet weak var createButton: UIButton!
    
    var user: User = User(name: "Jacob", points: 10000)
    
    @IBAction func buttonPressed(_ sender: Any) {
        if(challengeTitle.text != nil && challengeDescription.text != nil){
            user.addChallenge(challenge: Challenge(title: challengeTitle.text!, description: challengeDescription.text, creator: user))
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    


}

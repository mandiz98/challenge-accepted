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
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        if(challengeTitle.text != "" && challengeDescription.text != ""){
            
            userJacob.addChallenge(challenge: Challenge(title: challengeTitle.text!, description: challengeDescription.text, creator: userJacob, imageState: UIImage(named: "unread")!))
            
            print(userJacob.getAllChallenges().count)
        }
        
        else {print("Didn't add challenge")}
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    


}

//
//  HomeScreenViewController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-10-29.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AddNotification()
    }
    
    @IBAction func CreateBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateChallengeSegue", sender: self)
    }
    
    @IBAction func ProfileBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "ProfileSegue", sender: self)
    }
    
}

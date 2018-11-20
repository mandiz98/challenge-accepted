//
//  HomeScreenViewController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-10-29.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func CreateBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateChallengeSegue", sender: self)
    }
    
    @IBAction func ProfileBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "ProfileSegue", sender: self)
    }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

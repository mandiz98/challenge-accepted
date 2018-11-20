//
//  SentDetailViewController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-11-09.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit

class SentDetailViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var StateImage: UIImageView!
    @IBOutlet weak var StateLabel: UILabel!
    
    var challenge = Challenge(title: "", description: "", creator: "", imageState: UIImage(named: "unread")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TitleLabel.text = challenge.title
        NameLabel.text = challenge.getCreator()
        StateImage.image = challenge.imageState
        StateLabel.text = challenge.getStatus()
       
        
        // Do any additional setup after loading the view.
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

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
    @IBOutlet weak var StateImage: UIImageView!
    @IBOutlet weak var StateLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var recieverNameLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var imageProof: UIImageView!
    
    var checkIfSentOrRecieved: Int = -1
    
    var challenge = Challenge(title: "", description: "", creator: "", imageState: UIImage(named: "unread")!, state: Challenge.Status(rawValue: "unread")!, proof: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TitleLabel.text = challenge.title
        StateImage.image = challenge.imageState
        StateLabel.text = challenge.getStatus()
        DescriptionLabel.text = challenge.getDescription()
        if challenge.proof != ""{
            let data = NSData(contentsOf: URL(string: challenge.proof )!)
            imageProof.image = UIImage(data: data! as Data)
        }
        
        if checkIfSentOrRecieved == 0 {
            self.senderNameLabel.text = profileCache.name
            self.recieverNameLabel.text = challenge.getCreator()
        }
        else if checkIfSentOrRecieved == 1{
            self.senderNameLabel.text = challenge.getCreator()
            self.recieverNameLabel.text = profileCache.name
        }
    }
}

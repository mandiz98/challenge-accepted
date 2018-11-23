//
//  SendViewController.swift
//  Challenge Accepted
//
//  Created by Erik Andreasson on 2018-11-20.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import Firebase

class SendViewController: UIViewController {

    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var Description: UILabel!
    
    var challenge = Challenge(title:"",description:"",creator: "",imageState: UIImage(named:"unread")!, state: Challenge.Status(rawValue: "unread")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        challengeTitle.text = challenge.title
        creator.text = challenge.getCreator()
        status.image = challenge.imageState
        Description.text = challenge.getDescription()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var challengeKey = ""
        
        ref.child("challenges").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                for challenge in snapshot.children.allObjects as! [DataSnapshot]{
                    let attr = challenge.value as? [String:Any]
                    if (attr!["receiverId"] as? String == profileCache.userID && attr!["title"] as? String == self.challengeTitle.text){
                        challengeKey = challenge.key
                        ref.child("challenges/\(challengeKey)/state").setValue("accepted")
                    }
                }
            }
        })
        
        if let navController = self.navigationController {
            navController.popViewController(animated: false)
            navController.popViewController(animated: true)
            
        }
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

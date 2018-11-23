//
//  InboxDetailViewController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-11-09.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import Firebase

class InboxDetailViewController: UIViewController {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var StateImage: UIImageView!
    @IBOutlet weak var StateLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var AcceptButton: UIButton!
    @IBOutlet weak var DenyButton: UIButton!
    
    var challenge = Challenge(title:"",description:"",creator: "",imageState: UIImage(named:"unread")!, state: Challenge.Status(rawValue: "unread")!)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        TitleLabel.text = challenge.title
        NameLabel.text = challenge.getCreator()
        StateImage.image = challenge.imageState
        DescriptionLabel.text = challenge.getDescription()
        StateLabel.text = challenge.getStatus()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func AcceptPressed(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var challengeKey = ""
        
        ref.child("challenges").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                for challenge in snapshot.children.allObjects as! [DataSnapshot]{
                    let attr = challenge.value as? [String:Any]
                    if (attr!["receiverId"] as? String == globalUserID && attr!["title"] as? String == self.TitleLabel.text){
                        challengeKey = challenge.key
                        ref.child("challenges/\(challengeKey)/state").setValue("pending")
                    }
                }
            }
        })
        
        if let navController = self.navigationController {
            navController.popViewController(animated: false)
            navController.popViewController(animated: true)
            
        }

    }
    @IBAction func DenyPressed(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var challengeKey = ""
        
        ref.child("challenges").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                for challenge in snapshot.children.allObjects as! [DataSnapshot]{
                    let attr = challenge.value as? [String:Any]
                    if (attr!["receiverId"] as? String == globalUserID && attr!["title"] as? String == self.TitleLabel.text){
                        challengeKey = challenge.key
                        ref.child("challenges").child(challengeKey).removeValue()
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

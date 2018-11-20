//
//  HomeScreenViewController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-10-29.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import Firebase

var inboxChallenges: [Challenge] = []


class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()

        ref.child("challenges").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                for challenge in snapshot.children.allObjects as! [DataSnapshot]{
                    let attr = challenge.value as? [String:Any]
                    if attr!["receiverId"] as? String == globalUserID{
                        var creatorName = "hahfjsd"
                        ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                            if snapshot.childrenCount>0{
                                for user in snapshot.children.allObjects as! [DataSnapshot]{
                                    if user.key == attr!["creatorId"] as! String{
                                        let attr2 = user.value as? [String:Any]
                                        creatorName = attr2!["fname"] as! String
                                    }
                                }
                            }
                        inboxChallenges.append(Challenge(title: attr!["title"] as! String, description: attr!["description"] as! String, creator: creatorName,imageState: UIImage(named: "unread")!))
                        })
                    }
                }
            }
        })
        

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

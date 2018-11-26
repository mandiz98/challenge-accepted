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
var sentChallenges: [Challenge] = []


class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        inboxChallenges = []
        sentChallenges = []
        var sentState=""
        var inboxState=""
        
        ref.child("challenges").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                for challenge in snapshot.children.allObjects as! [DataSnapshot]{
                    let attr = challenge.value as? [String:Any]
                    if attr!["receiverId"] as? String == profileCache.userID{
                        var creatorName = ""
                        
                        ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                            if snapshot.childrenCount>0{
                                for user in snapshot.children.allObjects as! [DataSnapshot]{
                                    if user.key == attr!["creatorId"] as! String{
                                        let attr2 = user.value as? [String:Any]
                                        creatorName = attr2!["fname"] as! String
                                        if attr!["state"] as! String == "accepted"{
                                            inboxState="accepted"
                                        }
                                        if attr!["state"] as! String == "pending"{
                                            inboxState="pending"
                                        }
                                        if attr!["state"] as! String == "done"{
                                            inboxState="done"
                                        }
                                        if attr!["state"] as! String == "unread"{
                                            inboxState="unread"
                                        }
                                        inboxChallenges.append(Challenge(title: attr!["title"] as! String, description: attr!["description"] as! String, creator: creatorName,imageState: UIImage(named: inboxState)!, state: Challenge.Status(rawValue: inboxState)!))
                                    }
                                }
                                
                            }
                            
                        })
                        
                    }
                }
            }
        })
        
        ref.child("challenges").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                for challenge in snapshot.children.allObjects as! [DataSnapshot]{
                    let attr = challenge.value as? [String:Any]
                    if attr!["creatorId"] as? String == profileCache.userID{
                        var sentName = ""
                        
                        ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                            if snapshot.childrenCount>0{
                                for user in snapshot.children.allObjects as! [DataSnapshot]{
                                    if user.key == attr!["receiverId"] as! String{
                                        let attr2 = user.value as? [String:Any]
                                        sentName = attr2!["fname"] as! String
                                        if attr!["state"] as! String == "accepted"{
                                            sentState="accepted"
                                        }
                                        if attr!["state"] as! String == "pending"{
                                            sentState="pending"
                                        }
                                        if attr!["state"] as! String == "done"{
                                            sentState="done"
                                        }
                                        if attr!["state"] as! String == "unread"{
                                            sentState="unread"
                                        }
                                        sentChallenges.append(Challenge(title: attr!["title"] as! String, description: attr!["description"] as! String, creator: sentName,imageState: UIImage(named: sentState)!, state: Challenge.Status(rawValue: sentState)!))
                                    }
                                }
                                
                            }
                        })
                        
                    }
                }
            }
        })
    }

    @IBAction func CreateBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateChallengeSegue", sender: self)
    }
    
    @IBAction func ProfileBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "ProfileSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue"{
            let ref = Database.database().reference()
            ref.child("users").child(profileCache.userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let points = value?["score"] as? Int
                profileCache.score = points
                
            })
        }
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



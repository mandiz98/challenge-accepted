//
//  InboxTableViewController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import Firebase

class InboxTableViewController: UITableViewController{
    //MARK: Outlets
    @IBOutlet var inboxTable: UITableView!
    
    //MARK: Variables
    var inboxChallenges: [Challenge] = []

    //MARK: Functions
    override func viewDidAppear(_ animated: Bool) {
        var ref: DatabaseReference!
        var inboxState=""
        ref = Database.database().reference()
        ref.child("challenges").observe(DataEventType.value, with: { (snapshot) in
                self.inboxChallenges = []
                for challenge in snapshot.children.allObjects as! [DataSnapshot]{
                    let attr = challenge.value as? [String:Any]
                    if attr!["receiverId"] as? String == profileCache.userID{
                        var creatorName = ""
                        ref.child("users").observe(DataEventType.value, with: { (snapshot) in
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
                                        if attr!["state"] as! String == "denied"{
                                            inboxState="denied"
                                        }
                                        if attr!["state"] as! String == "unread"{
                                            inboxState="unread"
                                        }
                                        if inboxState != "denied"{
                                            self.inboxChallenges.append(Challenge(title: attr!["title"] as! String, description: attr!["description"] as! String, creator: creatorName,imageState: UIImage(named: inboxState)!, state: Challenge.Status(rawValue: inboxState)!, proof: attr!["proof"] as! String))
                                        }
                                        
                                    }
                                    self.inboxTable.reloadData()
                                }
                            }
                        })
                    }
                }

        })
        inboxTable.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ inboxTabel: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxChallenges.count
    }

    override func tableView(_ inboxTabel: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell", for: indexPath) as? InboxTableViewCell{
            let challenge = inboxChallenges[indexPath.row]
            cell.nameLabel.text = challenge.getCreator()
            cell.titleLabel.text = challenge.getTitel()
            cell.stateImageView.image = challenge.getStatusImage()
            
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? InboxDetailViewController {
            if let indexPath = sender as? IndexPath {
                let challenge = inboxChallenges[indexPath.row]
                destination.challenge = challenge
                
            }
        }
        if let destination = segue.destination as? SendViewController {
            if let indexPath = sender as? IndexPath {
                let challenge = inboxChallenges[indexPath.row]
                destination.challenge = challenge
            }
        }
        if let destination = segue.destination as? SentDetailViewController {
            if let indexPath = sender as? IndexPath {
                let challenge = inboxChallenges[indexPath.row]
                destination.challenge = challenge
                destination.checkIfSentOrRecieved = 1
            }
        }
    }
    
    override func tableView(_ inboxTabel: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inboxChallenges[indexPath.row].getStatus() == "unread"{
            performSegue(withIdentifier: "unreadSegue", sender: indexPath)
        }
        if inboxChallenges[indexPath.row].getStatus() == "pending"
        {
            performSegue(withIdentifier: "acceptedSegue", sender: indexPath)
        }
        if inboxChallenges[indexPath.row].getStatus() == "accepted"
        {
            performSegue(withIdentifier: "doneSegue", sender: indexPath)
        }
    }
}

//
//  SentTableViewController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import Firebase

class SentTableViewController: UITableViewController {

    //MARK: Outlets
    @IBOutlet var sentTable: UITableView!

    //MARK: Variables
    var sentChallenges: [Challenge] = []
    
    //MARK: Functions
    override func viewDidAppear(_ animated: Bool) {
        var ref: DatabaseReference!
        var sentState=""
        ref = Database.database().reference()
        ref.child("challenges").observe(DataEventType.value, with: { (snapshot) in
                self.sentChallenges = []
                for challenge in snapshot.children.allObjects as! [DataSnapshot]{
                    let attr = challenge.value as? [String:Any]
                    if attr!["creatorId"] as? String == profileCache.userID{
                        var sentName = ""
                        ref.child("users").observe(DataEventType.value, with: { (snapshot) in
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
                                        if attr!["state"] as! String == "denied"{
                                            sentState="denied"
                                        }
                                        if attr!["state"] as! String == "unread"{
                                            sentState="unread"
                                        }
                                        if sentState != "denied"{
                                            self.sentChallenges.append(Challenge(title: attr!["title"] as! String, description: attr!["description"] as! String, creator: sentName,imageState: UIImage(named: sentState)!, state: Challenge.Status(rawValue: sentState)!, proof: attr!["proof"] as! String))
                                        }
                                    }
                                    self.sentTable.reloadData()
                                }
                            }
                        })
                    }
                }
        })
        sentTable.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ sentTabel: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentChallenges.count
    }

    override func tableView(_ sentTabel: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SentTableViewCell", for: indexPath) as? SentTableViewCell{
            let challenge = sentChallenges[indexPath.row]
            cell.nameLabel.text = challenge.getCreator()
            cell.titleLabel.text = challenge.getTitel()
            cell.stateImageView.image = challenge.getStatusImage()
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SentDetailViewController {
            if let indexPath = sender as? IndexPath {
                let challenge = sentChallenges[indexPath.row]
                destination.challenge = challenge
                destination.checkIfSentOrRecieved = 0
            }
        }
    }
    
    override func tableView(_ sentTabel: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "pendingSegue", sender: indexPath)
    }
}

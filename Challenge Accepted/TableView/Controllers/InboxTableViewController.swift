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
    var inboxChallenges: [Challenge] = []

    
    @IBOutlet var inboxTabel: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        
        
        var ref: DatabaseReference!
        var inboxState=""
        ref = Database.database().reference()
        ref.child("challenges").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
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
                                        if attr!["state"] as! String == "done"{
                                            inboxState="done"
                                        }
                                        if attr!["state"] as! String == "unread"{
                                            inboxState="unread"
                                        }
                                        self.inboxChallenges.append(Challenge(title: attr!["title"] as! String, description: attr!["description"] as! String, creator: creatorName,imageState: UIImage(named: inboxState)!, state: Challenge.Status(rawValue: inboxState)!, proof: attr!["proof"] as! String))
                                    }
                                    self.inboxTabel.reloadData()

                                }
                                
                            }

                        })
                        
                    }
                }
            }

        })
        
        //inboxTableView.tableFooterView = UIView()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ProfileViewController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKCoreKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileScore: UILabel!
    @IBOutlet weak var scoreTableView: UITableView!
    
    // MARK: Variables
    var friendsID: [String] = []
    var friendInfo: [User] = []
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listFriendsID()
        self.ProfileName.text = profileCache.name
        self.ProfilePicture.image = profileCache.image
        self.ProfileScore.text = "Score: \(profileCache.score ?? 0)"
        scoreTableView.tableFooterView = UIView()
    }
    
    // MARK: Scoreboard functions
    
    func listFriendsID(){
        let parameters = ["fields": "id"]
        friendsID.append(profileCache.userID ?? "")
        // MARK: Facebook data request for UserIDs
        // Listing the userIDs for which we wan't to retrieve data from the database.
        FBSDKGraphRequest(graphPath: "/me/friends", parameters: parameters).start{
            (connection, result, err) in
            if err != nil{
                print(err!)
                return
            }
            let data:[String:Any] = result as! [String : Any]
            if let friendIDs = data["data"] as? [[String : Any]]{
                for friend in friendIDs {
                    self.friendsID.append(friend["id"] as! String)
                }
            }
            self.createListForCell()
        }
    }
    func createListForCell(){
        // MARK: Listing data from Database
        // Creating a complete list of all data necessery for the tableViewCell.
        for friend in friendsID{
            let ref = Database.database().reference()
            ref.child("users").child(friend).observe(DataEventType.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = "\(value?["fname"] as! String) \(value?["lname"] as! String)"
                let points = value?["score"] as? Int
                ref.child("users").child(friend).child("profileImage").child("data").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let imageURL = value?["url"]
                    let data = NSData(contentsOf: URL(string: imageURL! as! String)!)
                    let friend: User = User(name: name, score: points ?? 0, image: UIImage(data: data! as Data))
                    self.friendInfo.append(friend)
                    
                    // When list is done, we order it by score for the scoreboard and reaload the tableview.
                    if self.friendInfo.count == self.friendsID.count{
                        self.friendInfo.sort(by: { $0.score > $1.score } )
                        self.scoreTableView.reloadData()
                    }
                })
            })
        }
    }
    func tableView(_ scoreTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendInfo.count
    }
    func tableView(_ scoreTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = scoreTableView.dequeueReusableCell(withIdentifier: "ScoreboardTableViewCell", for: indexPath) as? ScoreboardTableViewCell{
                let name = friendInfo[indexPath.row].name
                let points = friendInfo[indexPath.row].score
                let image = friendInfo[indexPath.row].image
                cell.friendsName.text = name
                cell.friendsScore.text = "\(points)"
                cell.friendsImage.image = image
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}

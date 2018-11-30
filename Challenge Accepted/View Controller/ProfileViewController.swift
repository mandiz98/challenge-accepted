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
    
    var friendsID: [String] = []
    
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileScore: UILabel!
    @IBOutlet weak var scoreTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listFriends()
        print("********\nIn viewDidLoad\n*******", self.friendsID.count)
        self.ProfileName.text = profileCache.name
        self.ProfilePicture.image = profileCache.image
        self.ProfileScore.text = "Score: \(profileCache.score ?? 0)"
        scoreTableView.tableFooterView = UIView()
    }
    
    func listFriends(){
        let parameters = ["fields": "id"]
        friendsID.append(profileCache.userID ?? "")
        FBSDKGraphRequest(graphPath: "/me/friends", parameters: parameters).start{
            (connection, result, err) in
            if err != nil{
                print(err!)
                return
            }
            let data:[String:Any] = result as! [String : Any]
            if let friends = data["data"] as? [[String : Any]]{
                for friend in friends {
                    self.friendsID.append(friend["id"] as! String)
                    print("*****\n Listing friends\n*****" ,self.friendsID, self.friendsID.count)
                }
            }
            self.scoreTableView.reloadData()
        }
    }
    
    
    func tableView(_ scoreTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("******\n1***********", self.friendsID.count)
        return self.friendsID.count
    }
    
    func tableView(_ scoreTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("TEST NR 2*******\n*******\n*******\n******")
        if let cell = scoreTableView.dequeueReusableCell(withIdentifier: "ScoreboardTableViewCell", for: indexPath) as? ScoreboardTableViewCell{
            let friend = self.friendsID[indexPath.row]
            let ref = Database.database().reference()
            ref.child("users").child(friend).observe(DataEventType.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = "\(value?["fname"] as! String) \(value?["lname"] as! String)"
                let points = value?["score"] as? Int
                cell.friendsName.text = name
                cell.friendsScore.text = "\(points ?? 0)"
            })
            ref.child("users").child(friend).child("profileImage").child("data").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let imageURL = value?["url"]
                let data = NSData(contentsOf: URL(string: imageURL! as! String)!)
                cell.friendsImage.image = UIImage(data: data! as Data)
            })
            print("********Testar*********\n*****Testar*****\n*****Testar****", cell.friendsName, cell.friendsScore)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}

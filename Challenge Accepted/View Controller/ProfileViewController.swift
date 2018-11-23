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


class ProfileViewController: UIViewController{
    
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileScore: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ProfileName.text = profileCache.name
        self.ProfilePicture.image = profileCache.image
        self.ProfileScore.text = "Score: \(profileCache.score ?? 0)"
        getFreindsID()
    }
    
    
    func getFreindsID(){
        let parameters = ["fields": "id"]
        FBSDKGraphRequest(graphPath: "/me/friends", parameters: parameters).start{
            (connection, result, err) in
            if err != nil{
                print(err!)
                return
            }
            let data:[String:Any] = result as! [String : Any]
            if let friends = data["data"] as? [[String : Any]]{
                for friend in friends {
                    profileCache.friendsList.append(friend["id"] as! String)
                    print(profileCache.friendsList)
                }
            }
        }
    }
}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ref = Database.database().reference()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreboardTableViewCell", for: indexPath) as? ScoreboardTableViewCell{
            ref.child("users").child(profileCache.friendsList[indexPath.row]).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = "\(value?["fname"] as! String) \(value?["lname"] as! String)"
                cell.FriendName.text = name
                cell.FriendScore.text = "\(value?["score"] as? Int ?? 0)"
                
            })
            
        ref.child("users").child(profileCache.userID!).child("profileImage").child("data").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let imageURL = value?["url"] as! String
                let data = NSData(contentsOf: URL(string: imageURL)!)
                let image = UIImage(data: data! as Data)
                cell.FriendImage.image = image
            })
            print("RETURNING CELL *************************")
            return cell
        }else{
            print("RETURNING DEFAULT CELL******************")
            return UITableViewCell()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCache.friendsList.count
    }
 
}
//    override func didReceiveMemoryWarning() {
//        getNameFromDatabase()
//        getPicFromDatabase()
//    }

//    func getPicFromDatabase(){
//        var ref: DatabaseReference
//        ref = Database.database().reference()
//        ref.child("users").child(profileCache.userID!).child("profileImage").child("data").observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let imageURL = value?["url"] as! String
//            let data = NSData(contentsOf: URL(string: imageURL)!)
//            let image = UIImage(data: data! as Data)
//            self.ProfilePicture.image = image
//        })
//    }
//    func getNameFromDatabase(){
//        var ref: DatabaseReference
//        ref = Database.database().reference()
//        ref.child("users").child(profileCache.userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let name = "\(value?["fname"] as! String) \(value?["lname"] as! String)"
//            self.ProfileName.text = name
//        })
//    }

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
/*
 func getFacebookName(){
 let parameters = ["fields": "first_name, last_name"]
 FBSDKGraphRequest(graphPath: "/me", parameters: parameters).start{
 
 (connection, result, err) in
 if err != nil {
 print(err!)
 return
 }
 let data:[String:Any] = result as! [String:Any]
 self.ProfileName.text = "\(data["first_name"] as! String) \(data["last_name"] as! String)"
 }
 }
 
 func getFacebookPic(){
 let parameters = ["fields": "picture.width(512).height(512)"]
 FBSDKGraphRequest(graphPath: "/me", parameters: parameters).start{
 (connection, result, err) in
 if err != nil{
 print(err!)
 return
 }
 let field = result! as? [String:Any]
 let imageUrl = ((field!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
 print("Min URL:", imageUrl!)
 let data = NSData(contentsOf: URL(string: imageUrl!)!)
 let image = UIImage(data: data! as Data)
 self.ProfilePicture.image = image
 }
 
 }
 */

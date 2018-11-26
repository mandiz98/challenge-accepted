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


class ProfileViewController: UIViewController {
    
    var friendsID: [String] = []
    
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileScore: UILabel!
    @IBOutlet weak var scoreTableView: UITableView!
    
    override func viewDidLoad() {
        listFriends()
        super.viewDidLoad()
        
        self.ProfileName.text = profileCache.name
        self.ProfilePicture.image = profileCache.image
        self.ProfileScore.text = "Score: \(profileCache.score ?? 0)"
        scoreTableView.tableFooterView = UIView()
        
    }
    
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func listFriends(){
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
                    self.friendsID.append(friend["id"] as! String)
                    print("*****\n Listing friends\n*****" ,self.friendsID, self.friendsID.count)
                }
            }
        }
    }
    
    func tableView(_ scoreTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("*******\n*******\n*******\n******:", friendsID.count)
        return friendsID.count
    }
    
    func tableView(_ scoreTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("2*******\n*******\n*******\n******")
        if let cell = scoreTableView.dequeueReusableCell(withIdentifier: "scoreboardTableViewCell", for: indexPath) as? ScoreboardTableViewCell{
            let friend = friendsID[indexPath.row]
            let ref = Database.database().reference()
            ref.child("users").child(friend).observeSingleEvent(of: .value, with: { (snapshot) in
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

//    func getFacebookName(){
//        let parameters = ["fields": "first_name, last_name"]
//        FBSDKGraphRequest(graphPath: "/me/friends", parameters: parameters).start{
//
//            (connection, result, err) in
//            if err != nil {
//                print(err!)
//                return
//            }
//            let data:[String:Any] = result as! [String:Any]
//            self.ProfileName.text = "\(data["first_name"] as! String) \(data["last_name"] as! String)"
//        }
//    }

    


//func getFreindsID(){
//
//}








//    override func didReceiveMemoryWarning() {
//        getNameFromDatabase()
//        getPicFromDatabase()
//    }
//
//
//
//
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


 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
// override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
// // Get the new view controller using segue.destination.
// // Pass the selected object to the new view controller.
// }
//
//
//
// func getFacebookPic(){
// let parameters = ["fields": "picture.width(512).height(512)"]
// FBSDKGraphRequest(graphPath: "/me", parameters: parameters).start{
// (connection, result, err) in
// if err != nil{
// print(err!)
// return
// }
// let field = result! as? [String:Any]
// let imageUrl = ((field!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
// print("Min URL:", imageUrl!)
// let data = NSData(contentsOf: URL(string: imageUrl!)!)
// let image = UIImage(data: data! as Data)
// self.ProfilePicture.image = image
// }
//
// }
//

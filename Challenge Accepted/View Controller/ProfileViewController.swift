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
    var friendInfo: [User] = []
    
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileScore: UILabel!
    @IBOutlet weak var scoreTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listFriendsID()
        print("********\nIn viewDidLoad\n*******", self.friendsID.count)
        self.ProfileName.text = profileCache.name
        self.ProfilePicture.image = profileCache.image
        self.ProfileScore.text = "Score: \(profileCache.score ?? 0)"
        scoreTableView.tableFooterView = UIView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AddNotification()
    }
    
    func listFriendsID(){
        let parameters = ["fields": "id"]
        friendsID.append(profileCache.userID ?? "")
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
                    print("*****\n Listing friends\n*****" ,self.friendsID, self.friendsID.count)
                }
            }
            //self.scoreTableView.reloadData()
            self.createListForCell()
        }
    }
    func createListForCell(){
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
                    print("creating friendsList\n**********", self.friendInfo.count)
                    if self.friendInfo.count == self.friendsID.count{
                        self.friendInfo.sort(by: { $0.score > $1.score } )
                        self.scoreTableView.reloadData()
                    }
                })
            })
            
        }
        
    }
    
    func tableView(_ scoreTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("******\n1***********", self.friendsID.count)
        return self.friendInfo.count
    }
    
    func tableView(_ scoreTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("TEST NR 2*******\n*******\n*******\n******")
        if let cell = scoreTableView.dequeueReusableCell(withIdentifier: "ScoreboardTableViewCell", for: indexPath) as? ScoreboardTableViewCell{
                let name = friendInfo[indexPath.row].name
                let points = friendInfo[indexPath.row].score
                let image = friendInfo[indexPath.row].image
                cell.friendsName.text = name
                cell.friendsScore.text = "\(points)"
                cell.friendsImage.image = image
            print("********Testar*********\n*****Testar*****\n*****Testar****", cell.friendsName, cell.friendsScore)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}

//**************************
//let friend = self.friendsID[indexPath.row]
//let ref = Database.database().reference()
//ref.child("users").child(friend).observe(DataEventType.value, with: { (snapshot) in
//    let value = snapshot.value as? NSDictionary
//    let name = "\(value?["fname"] as! String) \(value?["lname"] as! String)"
//    let points = value?["score"] as? Int
//***************************
//ref.child("users").child(friend).child("profileImage").child("data").observeSingleEvent(of: .value, with: { (snapshot) in
//    let value = snapshot.value as? NSDictionary
//    let imageURL = value?["url"]
//    let data = NSData(contentsOf: URL(string: imageURL! as! String)!)
//    cell.friendsImage.image = UIImage(data: data! as Data)
//})
//*************************







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


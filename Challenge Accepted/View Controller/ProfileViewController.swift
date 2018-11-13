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
    
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNameFromDatabase()
        getPicFromDatabase()
    }
    
    func getPicFromDatabase(){
        var ref: DatabaseReference
        ref = Database.database().reference()
        ref.child("users").child(globalUserID).child("profileImage").child("data").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let imageURL = value?["url"] as! String
            let data = NSData(contentsOf: URL(string: imageURL)!)
            let image = UIImage(data: data! as Data)
            self.ProfilePicture.image = image
        })
    }
    func getNameFromDatabase(){
        var ref: DatabaseReference
        ref = Database.database().reference()
        ref.child("users").child(globalUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = "\(value?["fname"] as! String) \(value?["lname"] as! String)"
            self.ProfileName.text = name
        })
    }
    
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
}

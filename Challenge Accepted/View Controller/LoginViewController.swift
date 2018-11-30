//
//  LoginViewController.swift
//  Challenge Accepted
//
//  Created by Erik Andreasson on 2018-10-30.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import UserNotifications

var profileCache: Profile = Profile()

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    var fbLoginSuccess = false
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    let center = UNUserNotificationCenter.current()
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("inloggad")
        fbLoginSuccess = true
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("utloggad")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if FBSDKAccessToken.currentAccessTokenIsActive() {
            // User is logged in, use 'accessToken' here.
            fbLoginSuccess = true
            fetchProfile()
        }else{
            fbLoginSuccess = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile", "user_friends"]
        loginButton.center = view.center
        
        let options: UNAuthorizationOptions = [.alert, .sound]
    
        center.requestAuthorization(options: options) {
            (granted, error) in if !granted {
                print("Something went wrong")
            }
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized{
                //Notifications not allowed
            }                                                                                                           
        }
        
        view.addSubview(loginButton)
    }
    
    @IBAction func startPressed(_ sender: Any) {
        if(fbLoginSuccess){
            UIButton.animate(withDuration: 1, animations:{
                self.startButton.transform = CGAffineTransform(scaleX: -1, y: -1)
                self.startButton.transform = CGAffineTransform(scaleX: 1, y: 1) 
            }, completion:{
                (finished: Bool) in
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            })
        }
        else{
            showAlert(startButton)
        }
    }
    
    @IBAction func showAlert(_ sender: UIButton){
        //create the alert
        let alert = UIAlertController(title: "Error!", message: "Login to continue.", preferredStyle: UIAlertController.Style.alert)
        
        //Add Action
        alert.addAction(UIAlertAction(title: "Ok",style: UIAlertAction.Style.default, handler: nil))
        
        //Show Alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchProfile(){
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        let parameters = ["fields": "first_name, last_name, email, id, picture.width(512).height(512)"]

        
        FBSDKGraphRequest(graphPath: "/me", parameters: parameters).start{
            (connection, result, err) in
            
            if err != nil{
                print(err!)
                return
            }
            
            let data:[String:Any] = result as! [String : Any]
            
            // ***** USING GLOBAL VARIABLE FOR DATABASE USER ID!!! *****
            //globalUserID = data["id"] as! String

            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(data["id"] as! String){
                    
                    print("User exist")
                    
                }else{
                    print("User added to database")
                    
                    ref.child("users").child(data["id"] as! String).setValue(["fname": data["first_name"], "lname":data["last_name"], "email":data["email"], "score":0, "profileImage":data["picture"]])
                }
                self.cacheProfile(ref: ref, userID: data["id"] as! String)
                
            })
        }
        
        FBSDKGraphRequest(graphPath: "/me/friends", parameters: parameters).start{
            (connection, result, err) in
            
            if err != nil{
                print(err!)
                return
            }
            
            let data:[String:Any] = result as! [String : Any]
            //print(data["data"]!)
            
            names.removeAll()
            if let users = data["data"] as? [[String : Any]] {
                for user in users {
                    names.append(user["id"] as! String)
                    print(user["first_name"]!,user["last_name"]!)
                }
            }
        }
    }
    
    func cacheProfile(ref: DatabaseReference, userID: String){
        ref.child("users").child(userID).child("profileImage").child("data").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let imageURL = value?["url"]
            let data = NSData(contentsOf: URL(string: imageURL! as! String)!)
            profileCache.image = UIImage(data: data! as Data)
        })
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = "\(value?["fname"] as! String) \(value?["lname"] as! String)"
            let points = value?["score"] as? Int
            profileCache.name = name
            profileCache.score = points
            profileCache.userID = userID
            
        })
    }
}

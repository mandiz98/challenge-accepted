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


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    var fbLoginSuccess = false

    
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("inloggad")
        fbLoginSuccess = true
        fetchProfile()
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("utloggad")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(fbLoginSuccess){
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            fbLoginSuccess = false
        }

        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile", "user_friends"]
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
        
        
        
        if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            fbLoginSuccess = true
            fetchProfile()
        }
        
        
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
            globalUserID = data["id"] as! String

            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(data["id"] as! String){
                    
                    print("User exist")
                    
                }else{
                    print("User added to database")
                    
                    ref.child("users").child(data["id"] as! String).setValue(["fname": data["first_name"], "lname":data["last_name"], "email":data["email"], "score":0, "profileImage":data["picture"]])
                }
                
                
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
            
            
            if let users = data["data"] as? [[String : Any]] {
                for user in users {
                    names.append(user["id"] as! String)
                    print(user["first_name"]!,user["last_name"]!)
                }
            }
        }
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

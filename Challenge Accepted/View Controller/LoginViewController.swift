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
import SQLite



class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    var fbLoginSuccess = false
    var db: OpaquePointer?

    
    
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
        let parameters = ["fields": "first_name, last_name"]
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

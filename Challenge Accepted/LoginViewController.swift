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



class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    var fbLoginSuccess = false
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("inloggad")
        fbLoginSuccess = true
        
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("utloggad")
    }
    
   /*
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result{
        case .failed(let error):
            print("error")
            print(error)
            break
        case .cancelled:
            print("cancelled")
            break
        case .success(_,_,_):
            print("login")
            fbLoginSuccess = true
            break
        }
        
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        if(fbLoginSuccess){
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    
    /*func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("utloggad")
    }*/

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
            fbLoginSuccess = false
            fetchProfile()
        }
        
        

    }
    
    func fetchProfile(){
        let parameters = ["fields": "id, name, email, friends"]
        FBSDKGraphRequest(graphPath: "/me/friends", parameters: parameters).start{
            (connection, result, err) in
            
            if err != nil{
                print(err!)
                return
            }
            
            let data:[String:AnyObject] = result as! [String : AnyObject]
            print(data)
            
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

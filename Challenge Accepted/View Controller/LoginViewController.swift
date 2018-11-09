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


class LoginViewController: UIViewController, LoginButtonDelegate {
   var fbLoginSuccess = false
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
            print("after segue")
            fbLoginSuccess = true
            break
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(fbLoginSuccess){
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("utloggad")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            fbLoginSuccess = false
        }

        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.delegate = self
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.

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

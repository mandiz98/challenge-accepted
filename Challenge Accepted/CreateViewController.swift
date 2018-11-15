//
//  CreateViewController.swift
//  Challenge Accepted
//
//  Created by Jacob Carlquist on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKCoreKit
import Firebase
var names:[String]=[]

var selectedCellTapped = false

class CreateViewController: UIViewController {
    let parameters = ["fields": "first_name, last_name, email, id, picture"]

    
    
    @IBOutlet weak var challengeTitle: UITextField!
    @IBOutlet weak var challengeDescription: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        if(challengeTitle.text != "" && challengeDescription.text != ""){
            
            
            
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            
            
            FBSDKGraphRequest(graphPath: "/me", parameters: parameters).start{
                (connection, result, err) in
                
                if err != nil{
                    print(err!)
                    return
                }
                
                let data:[String:Any] = result as! [String : Any]
                
                
               
                print("Challenge added to database")
                        
                ref.child("challenges").childByAutoId().setValue(["description": self.challengeDescription.text!, "title":self.challengeTitle.text!, "state": 0, "creatorId": data["id"]!])
                
                    
                    
                
            }
            
            
        }
        
        else {print("Didn't add challenge")}
        
        
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
        // Do any additional setup after loading the view.
    }

}


extension CreateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionViewCell", for: indexPath) as? FriendCollectionViewCell {
            let name: String = names[indexPath.row]
            cell.friendLabel.text = name
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath!)!
        
        if !selectedCellTapped{
            selectedCell.layer.cornerRadius = 5
            selectedCell.layer.borderWidth = 5
            selectedCell.layer.borderColor = UIColor(named: "YellowByAmanda")?.cgColor
            selectedCellTapped=true
        }
        else{
            let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath!)!
            selectedCell.layer.cornerRadius = 5
            selectedCell.layer.borderWidth = 5
            selectedCell.layer.borderColor = UIColor(named: "SecondaryGrayByAmanda")?.cgColor
            selectedCellTapped=false
        }
    }
}


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
var sendTo:[String]=[]


var selectedCellTapped: [Bool] = []


class CreateViewController: UIViewController {
    let parameters = ["fields": "first_name, last_name, email, id, picture"]

    
    
    @IBOutlet weak var challengeTitle: UITextField!
    @IBOutlet weak var challengeDescription: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        if(challengeTitle.text != "" && challengeDescription.text != "" && !sendTo.isEmpty){
            
            
            
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
                
                for a in sendTo{
                    ref.child("challenges").childByAutoId().setValue(["description": self.challengeDescription.text!, "title":self.challengeTitle.text!, "state": 0, "creatorId": data["id"]!, "receiverId": a])
                }
                
            }
            
            performSegue(withIdentifier: "goBackAfterCreate", sender: Any?.self)
        }
        
        else {print("Didn't add challenge")}
        
        
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var count=0
        while count<names.count{
            selectedCellTapped.append(false)
            count += 1
        }
        
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
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount>0{
                    for user in snapshot.children.allObjects as! [DataSnapshot]{
                        if user.key == name{
                            let attr = user.value as? [String:Any]
                            cell.friendLabel.text = attr!["fname"]! as? String
                        }
                    }
                }
            })
            
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath!)!
        
        
        
        if !selectedCellTapped[(indexPath?.row)!]{
            selectedCell.layer.cornerRadius = 5
            selectedCell.layer.borderWidth = 5
            selectedCell.layer.borderColor = UIColor(named: "YellowByAmanda")?.cgColor
            selectedCellTapped[(indexPath?.row)!]=true
            sendTo.append(names[(indexPath?.row)!])
            print(sendTo)
        }
        else{
            let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath!)!
            selectedCell.layer.cornerRadius = 5
            selectedCell.layer.borderWidth = 5
            selectedCell.layer.borderColor = UIColor(named: "SecondaryGrayByAmanda")?.cgColor
            selectedCellTapped[(indexPath?.row)!]=false
            var temp:[String]=[]
            for a in sendTo{
                if names[(indexPath?.row)!] != a{
                    temp.append(a)
                }
            }
            sendTo = temp
            print(sendTo)

        }
    }
}


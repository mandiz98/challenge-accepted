//
//  SendViewController.swift
//  Challenge Accepted
//
//  Created by Erik Andreasson on 2018-11-20.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class SendViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var addedImage: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var photoimage: UIImage!
    var urlString = ""

    
    enum imageSource {
        case camera
        case photoLibrary
    }
    
    var challenge = Challenge(title:"",description:"",creator: "",imageState: UIImage(named:"unread")!, state: Challenge.Status(rawValue: "unread")!,proof:"")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        challengeTitle.text = challenge.title
        creator.text = challenge.getCreator()
        status.image = challenge.imageState
        Description.text = challenge.getDescription()
        // Do any additional setup after loading the view.
    }
    
    func addNewPicture(_ source: imageSource) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker,animated: true,completion: nil)
    }
    //Change button to be button in collection view
    @IBAction func addNewPictureBtn(_ sender: Any) {
            // create the alert
        let alert = UIAlertController(title: "Picture from:", message: "", preferredStyle: UIAlertController.Style.alert)
            
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "PhotoLibrary", style: UIAlertAction.Style.default, handler: {action in self.addNewPicture(.photoLibrary)}))
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: {action in
            self.addNewPicture(.camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedItem = info[.originalImage] as? UIImage else{
            return print("image not found")
        }
        addedImage.image = selectedItem
        photoimage = selectedItem
        saveImage(image: selectedItem)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if(urlString != ""){
            var ref: DatabaseReference!
            ref = Database.database().reference()
            var challengeKey = ""
            
            ref.child("challenges").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount>0{
                    for challenge in snapshot.children.allObjects as! [DataSnapshot]{
                        let attr = challenge.value as? [String:Any]
                        if (attr!["receiverId"] as? String == profileCache.userID && attr!["title"] as? String == self.challengeTitle.text){
                            challengeKey = challenge.key
                            ref.child("challenges/\(challengeKey)/state").setValue("accepted")
                            ref.child("challenges/\(challengeKey)/proof").setValue(self.urlString)
                        }
                    }
                }
            })
            ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount>0{
                    for users in snapshot.children.allObjects as! [DataSnapshot]{
                        if users.key == profileCache.userID{
                            let attr = users.value as? [String:Any]
                            let point = attr!["score"] as! integer_t + 100
                            ref.child("users/\(users.key)/score").setValue(point)
                            self.updateScore()
                        }

                    }
                }
            })
            
            
            
            if let navController = self.navigationController {
                navController.popViewController(animated: false)
                navController.popViewController(animated: true)
                
            }
        }
    }
    func updateScore(){
        let ref = Database.database().reference()
        ref.child("users").child(profileCache.userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let points = value?["score"] as? Int
            profileCache.score = points
        })
    }
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    func saveImage(image: UIImage){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        let random = NSUUID().uuidString

        let finalImage = imagesRef.child(random+".jpg")
        
        let data = image.jpegData(compressionQuality: 0.5)!
        
         finalImage.putData(data, metadata: nil) { (metadata, error) in
            if let error = error{
                print(error)
            }
            
            // Metadata contains file metadata such as size, content-type.
            //let size = metadata.size
            // You can also access to download URL after upload.
            finalImage.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                self.urlString = downloadURL.absoluteString
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



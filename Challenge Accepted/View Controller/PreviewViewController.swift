//
//  PreviewViewController.swift
//  Challenge Accepted
//
//  Created by Dennis Molund on 2018-11-13.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    //self.image is the current photo taken by user.
    var image: UIImage!
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //User.getchallange.addMedia(self.image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AddNotification()
    }
}

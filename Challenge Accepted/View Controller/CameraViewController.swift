//
//  CameraViewController.swift
//  Challenge Accepted
//
//  Created by Dennis Molund on 2018-11-13.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBAction func cameraButton(_ sender: Any) {
        performSegue(withIdentifier: "photoSegue", sender: nil) //sender is the object we want to use to initiate the segue
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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

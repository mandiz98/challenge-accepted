//
//  RoundImageView.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-11-06.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
}

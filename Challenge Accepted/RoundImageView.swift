//
//  RoundImageView.swift
//  MVCDemo
//
//  Created by Ebbas on 2018-11-01.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    
    //Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //makes imageView round
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}

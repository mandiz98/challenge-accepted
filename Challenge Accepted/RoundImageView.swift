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
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.red {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}

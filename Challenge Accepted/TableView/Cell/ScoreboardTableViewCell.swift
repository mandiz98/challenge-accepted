//
//  ScoreboardTableViewCell.swift
//  Challenge Accepted
//
//  Created by Jacob Carlquist on 2018-11-09.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit

class ScoreboardTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var friendsImage: UIImageView!
    @IBOutlet weak var friendsName: UILabel!
    @IBOutlet weak var friendsScore: UILabel!
    
    //MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//
//  ScoreboardTableViewCell.swift
//  Challenge Accepted
//
//  Created by Jacob Carlquist on 2018-11-09.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit

class ScoreboardTableViewCell: UITableViewCell {

    @IBOutlet weak var FriendImage: UIImageView!
    @IBOutlet weak var FriendName: UILabel!
    @IBOutlet weak var FriendScore: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

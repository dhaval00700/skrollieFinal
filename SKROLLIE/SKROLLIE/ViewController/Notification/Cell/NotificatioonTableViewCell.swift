//
//  NotificatioonTableViewCell.swift
//  SKROLLIE
//
//  Created by PC on 01/10/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class NotificatioonTableViewCell: UITableViewCell {

    @IBOutlet weak var viwContainer: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

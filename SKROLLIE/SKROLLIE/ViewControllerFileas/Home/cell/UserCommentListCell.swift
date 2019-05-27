//
//  UserCommentListCell.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 5/21/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class UserCommentListCell: UITableViewCell {

    @IBOutlet weak var imgUserProfile: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

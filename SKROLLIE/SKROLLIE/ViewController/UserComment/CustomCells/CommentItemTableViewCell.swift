//
//  CommentItemTableViewCell.swift
//  SKROLLIE
//
//  Created by Apexa on 28/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class CommentItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblUserComment: UILabel!
    @IBOutlet weak var btnReply: UIButton!

    
    var imgOfUser = String()
    var Username = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

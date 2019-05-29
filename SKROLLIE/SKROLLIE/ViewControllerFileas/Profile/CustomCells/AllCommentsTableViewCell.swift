//
//  AllCommentsTableViewCell.swift
//  SKROLLIE
//
//  Created by Apexa on 28/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class AllCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblUserComment: UILabel!
    
    @IBOutlet weak var lctSubCommentTableHeight: NSLayoutConstraint!
    @IBOutlet weak var tblSubComment: UITableView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

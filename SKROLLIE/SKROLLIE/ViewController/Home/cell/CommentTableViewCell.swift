//
//  CommentTableViewCell.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 5/21/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    // MARK: - Outlet
    
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var textviewUserComment: UITextView!
    
    @IBOutlet weak var btnReply: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}

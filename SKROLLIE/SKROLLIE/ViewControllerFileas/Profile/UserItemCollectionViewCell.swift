//
//  UserItemCollectionViewCell.swift
//  SKROLLIE
//
//  Created by Apexa on 28/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class UserItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viwUsernameContainer: UIView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
        
        viwUsernameContainer.layer.cornerRadius = 8.0
        imgUserProfile.layer.borderColor = UIColor.white.cgColor
        imgUserProfile.layer.borderWidth = 2
    }
    
    func setFont()
    {
        lblUserName.font = UIFont.Bold(ofSize: 13)
        
    }

}

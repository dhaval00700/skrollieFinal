//
//  FriendCollectionViewCell.swift
//  SKROLLIE
//
//  Created by PC on 14/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var viwMainContainer: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var imgTag: UIImageView!
    @IBOutlet weak var btnTodayPostCount: UIButton!
    @IBOutlet weak var btnForeverCount: UIButton!
    
    // MARK: - LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    // MARK: - Methods
    private func setupUI() {
        viwMainContainer.addCornerRadius(8)
        imgTag.isHidden = true
        imgTag.image = #imageLiteral(resourceName: "ic_shield").tintWithColor(#colorLiteral(red: 0.2509279847, green: 0.1815860868, blue: 0.3583279252, alpha: 1))
    }
    
    
    // MARK: - Actions
}

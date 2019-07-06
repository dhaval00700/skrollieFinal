//
//  FriendTableViewCell.swift
//  SKROLLIE
//
//  Created by PC on 06/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var viwMainContainer: UIView!
    @IBOutlet weak var viwImageProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserDescription: UILabel!
    @IBOutlet weak var imgShield: UIImageView!
    @IBOutlet weak var btnConnect: UIButton!
    
    // MARK: - Properties

    // MARK: - LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    private func setupUI() {
        imgShield.isHidden = true
        imgShield.image = #imageLiteral(resourceName: "ic_shield").tintWithColor(#colorLiteral(red: 0.2509279847, green: 0.1815860868, blue: 0.3583279252, alpha: 1))
        imgProfile.addCornerRadius(imgProfile.frame.height/2.0)
        viwImageProfile.addCornerRadius(viwImageProfile.frame.height/2.0)
        viwImageProfile.addShadow(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), opacity: 0.2, offset: .zero, radius: 3)
        viwMainContainer.addCornerRadius(5)
        btnConnect.addCornerRadius(8.0)
    }
    
    // MARK: - Actions
    
}

//
//  SearchItemCollectionViewCell.swift
//  SKROLLIE
//
//  Created by PC on 01/08/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class SearchItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viwMainContainer: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var imgTag: UIImageView!
    @IBOutlet weak var btnTodayPostCount: UIButton!
    @IBOutlet weak var btnForeverCount: UIButton!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnMore: UIButton!

    var moreDropDown: DropDown!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        viwMainContainer.addCornerRadius(8)
        btnTodayPostCount.addCornerRadius(8)
        btnForeverCount.addCornerRadius(8)
        btnConnect.addCornerRadius(8)

        imgTag.isHidden = true
        imgTag.image = #imageLiteral(resourceName: "ic_shield").tintWithColor(#colorLiteral(red: 0.2509279847, green: 0.1815860868, blue: 0.3583279252, alpha: 1))
    }
    
    func configureCellWithData(_ currentObj: UserFriendList) {
        lblUserName.text = currentObj.username
        imgUserPhoto.imageFromURL(link: currentObj.image, errorImage: #imageLiteral(resourceName: "img3"), contentMode: .scaleAspectFill)
        btnConnect.isHidden = false
        if currentObj.IsAccountVerify == AccountVerifyStatus.zero || currentObj.IsAccountVerify == AccountVerifyStatus.one {
            imgTag.isHidden = true
        } else {
            imgTag.isHidden = false
        }
        btnConnect.isUserInteractionEnabled = true
        if currentObj.FriendStatus.lowercased() == FriendStatus.Disconnect.lowercased() || currentObj.FriendStatus.lowercased() == FriendStatus.UnFriend.lowercased() {
            btnConnect.setTitle("Connect", for: .normal)
        } else if currentObj.FriendStatus.lowercased() == FriendStatus.Friend.lowercased() {
            btnConnect.isHidden = true
        } else if currentObj.FriendStatus.lowercased() == FriendStatus.Requested.lowercased() {
            btnConnect.setTitle("Connect Requested", for: .normal)
            btnConnect.isUserInteractionEnabled = false
        }
        setDropDown(currentObj)
    }
    
    private func setDropDown(_ currentObj: UserFriendList) {
        moreDropDown = DropDown()
        
        moreDropDown.anchorView = btnMore
        if currentObj.FriendStatus.lowercased() == FriendStatus.Disconnect.lowercased() || currentObj.FriendStatus.lowercased() == FriendStatus.UnFriend.lowercased() {
            moreDropDown.dataSource = ["Report"]
        } else if currentObj.FriendStatus.lowercased() == FriendStatus.Friend.lowercased() {
            moreDropDown.dataSource = ["Disconnect", "Report", "Block"]
        } else if currentObj.FriendStatus.lowercased() == FriendStatus.Requested.lowercased() {
            moreDropDown.dataSource = ["Cancle Request", "Report"]
        }
        moreDropDown.backgroundColor = .clear
        moreDropDown.bottomOffset = CGPoint(x: -moreDropDown.frame.width, y: -50)
        
        moreDropDown.width = 110
    }
    
    @IBAction func onBtnMore(_ sender: UIButton) {
        moreDropDown.show()
    }
}

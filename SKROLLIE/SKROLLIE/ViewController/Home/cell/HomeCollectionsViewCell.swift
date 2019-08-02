//
//  HomeCollectionsView swift
//  SKROLLIE
//
//  Created by bin on 05/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class HomeCollectionsViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imgUserPic: UIImageView!
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var lblTimeOfPhotos: UILabel!
    @IBOutlet weak var viewAllocColourDependOnTime: UIView!
    @IBOutlet weak var lctViewAllocHeight: NSLayoutConstraint!
    
    // MARK: - LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        lblTimeOfPhotos.isHidden = true
    }
    
    func ConfigureCellWithData(_ data: Post) {
        imgBackGround.imageFromURL(link: data.Url, errorImage: UIImage(named: "img1"), contentMode: .scaleAspectFill)
        
        lblTimeOfPhotos.font = UIFont.Regular(ofSize: 12)
        
        if  !data.Isforever || data.timeIntervalFromCurrent > 0 {
            lblTimeOfPhotos.text = "24 H O U R S  L E F T"
            viewAllocColourDependOnTime.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.7490196078, blue: 0.1333333333, alpha: 1)
            getHeightFromTime(data)
        } else {
            lblTimeOfPhotos.text = "F O R E V E R"
            viewAllocColourDependOnTime.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9098039216, blue: 0.1529411765, alpha: 1)
            lctViewAllocHeight.constant = 80
        }
    }
    
    func getHeightFromTime(_ data: Post) {
        data.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: data, repeats: true)
    }
    
    @objc func updateTimer(timer: Timer) {
        let userInfo = timer.userInfo as! Post
        if userInfo.timeIntervalFromCurrent < 0 {
            timer.invalidate()
        } else {
            userInfo.timeIntervalFromCurrent -= 1
            let percentage = (userInfo.timeIntervalFromCurrent / oneDayTimeInterval) * 100
            print(userInfo.timeIntervalFromCurrent, oneDayTimeInterval)
            print("Post Time percentage", percentage)
            let height = (80 * percentage) / 100
            print("View Height", height)
            lctViewAllocHeight.constant = CGFloat(height)
        }
    }
}

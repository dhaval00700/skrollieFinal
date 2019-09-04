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
        viewAllocColourDependOnTime.isHidden = true
    }
    
    func ConfigureCellWithData(_ data: Post) {
        
        lblTimeOfPhotos.font = UIFont.Regular(ofSize: 12)
        imgBackGround.imageFromURL(link: data.Url, errorImage: postPlaceHolder, contentMode: .scaleAspectFill)
        if  data.timeIntervalFromCurrent > 0 {
            viewAllocColourDependOnTime.isHidden = false
            if !data.Isforever {
                viewAllocColourDependOnTime.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.7490196078, blue: 0.1333333333, alpha: 1)
            } else {
                viewAllocColourDependOnTime.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9098039216, blue: 0.1529411765, alpha: 1)
            }
            getHeightFromTime(data)
        } else {
            viewAllocColourDependOnTime.isHidden = true
            lctViewAllocHeight.constant = 0
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
            //DLog(userInfo.timeIntervalFromCurrent, oneDayTimeInterval)
            //DLog("Post Time percentage", percentage)
            let height = (120 * percentage) / 100
            //DLog("View Height", height)
            UIView.animate(withDuration: 1.5) {
                self.lctViewAllocHeight.constant = CGFloat(height)
                self.viewAllocColourDependOnTime.layoutIfNeeded()
            }
        }
    }
}

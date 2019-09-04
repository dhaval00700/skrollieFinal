//
//  UserPostCollectionViewCell.swift
//  SKROLLIE
//
//  Created by PC on 08/08/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AVKit

class UserPostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viwPost: UIView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var viwHrLine: UIView!
    @IBOutlet weak var emoji1: UIButton!
    @IBOutlet weak var emoji2: UIButton!
    @IBOutlet weak var btnUserProfile: UIButton!
    @IBOutlet weak var imgWaterMark: UIImageView!
    @IBOutlet weak var imgAccountVerified: UIImageView!
    @IBOutlet weak var lctViwHrLine: NSLayoutConstraint!
    @IBOutlet weak var btnMore: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
        imgPost.isHidden = false
        viwPost.isHidden = true
        imgWaterMark.alpha = 0
        imgAccountVerified.image = #imageLiteral(resourceName: "ic_shield").tintWithColor(#colorLiteral(red: 0.2509279847, green: 0.1815860868, blue: 0.3583279252, alpha: 1))

    }

    var playerLayer : AVPlayerLayer!
    
    func ConfigureDatWithCell(_ currentObj: Post) {
        lblUserName.text = currentObj.Description
        
        imgPost.imageFromURL(link: currentObj.Url, errorImage: postPlaceHolder, contentMode: .scaleAspectFill)
        if !currentObj.LikeEmoji.isEmpty {
            let likeEmoji = EmojiStatus(rawValue: Int(currentObj.LikeEmoji)!)!.description()
            imgWaterMark.image = likeEmoji
            imgWaterMark.alpha = 0.7
            imgWaterMark.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.65)
        }

        
        if !currentObj.isPhoto {
            let playerItem = AVPlayerItem(url: URL(string: currentObj.Url)!)
            var avPlayer = AVPlayer()
            avPlayer = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: avPlayer)
            
            playerLayer.videoGravity = .resizeAspectFill
            delay(time: 1.5) {
                self.viwPost.layoutIfNeeded()
                self.viwPost.layoutIfNeeded()
                self.playerLayer.frame.size = self.viwPost.bounds.size
                self.playerLayer.layoutIfNeeded()
                self.viwPost.layer.addSublayer(self.playerLayer)
                avPlayer.play()
                self.imgPost.isHidden = true
                self.viwPost.isHidden = false
            }
        } else {
            imgPost.isHidden = false
            viwPost.isHidden = true
            if playerLayer != nil {
                playerLayer.removeFromSuperlayer()
            }
        }
        
        
        if  currentObj.timeIntervalFromCurrent > 0 {
            viwHrLine.isHidden = false
            if !currentObj.Isforever {
                viwHrLine.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.7490196078, blue: 0.1333333333, alpha: 1)
            } else {
                viwHrLine.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9098039216, blue: 0.1529411765, alpha: 1)
            }
            getHeightFromTime(currentObj)
        } else {
            viwHrLine.isHidden = true
            lctViwHrLine.constant = 0
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
            let height = (200 * percentage) / 100
            //DLog("View Height", height)
            UIView.animate(withDuration: 1.5) {
                self.lctViwHrLine.constant = CGFloat(height)
                self.viwHrLine.layoutIfNeeded()
            }
        }
    }
}

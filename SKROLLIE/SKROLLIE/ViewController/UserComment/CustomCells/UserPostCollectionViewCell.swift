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
    @IBOutlet weak var lblDateTime: UILabel!

    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var viwHrLine: UIView!
    @IBOutlet weak var emoji1: UIButton!
    @IBOutlet weak var emoji2: UIButton!
    @IBOutlet weak var btnUserProfile: UIButton!
    @IBOutlet weak var imgWaterMark: UIImageView!
    @IBOutlet weak var imgAccountVerified: UIImageView!
    @IBOutlet weak var lctViwHrLine: NSLayoutConstraint!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnMuteControll: UIButton!
    @IBOutlet weak var stkViwControlls: UIStackView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
        imgPost.isHidden = false
        viwPost.isHidden = true
        stkViwControlls.isHidden = true
        imgWaterMark.alpha = 0
        imgAccountVerified.image = #imageLiteral(resourceName: "ic_shield").tintWithColor(#colorLiteral(red: 0.2509279847, green: 0.1815860868, blue: 0.3583279252, alpha: 1))

        btnMuteControll.addCornerRadius(btnMuteControll.frame.height/2.0)
        
        btnPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        btnPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .selected)
        
        btnPlayPause.isSelected = true
        
        btnMuteControll.setImage(#imageLiteral(resourceName: "Unmute"), for: .normal)
        btnMuteControll.setImage(#imageLiteral(resourceName: "Mute"), for: .selected)
        
        emoji1.setBackgroundImage(UIImage(named: "blankHappy"), for: .highlighted)
        emoji1.setBackgroundImage(UIImage(named: "blankHappy")?.tintWithColor(.lightGray), for: .normal)
        
        emoji2.setBackgroundImage(UIImage(named: "blankSad"), for: .highlighted)
        emoji2.setBackgroundImage(UIImage(named: "blankSad")?.tintWithColor(.lightGray), for: .normal)
        
        emoji1.isHighlighted = false
        emoji2.isHighlighted = false
        
    }
    
    var curObj = Post()
    
    func ConfigureDatWithCell(_ currentObj: Post) {
        curObj = currentObj
        lblUserName.text = currentObj.Description
        if !currentObj.LikeEmoji.isEmpty {
            let likeEmoji = EmojiStatus(rawValue: Int(currentObj.LikeEmoji)!)!.description()
            imgWaterMark.image = likeEmoji
            imgWaterMark.alpha = 0.7
            imgWaterMark.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.65)
        }
        lblDateTime.text = Utility.getPostTime(postDate: currentObj.CreatedNsDate)

        
        if !currentObj.isPhoto {
            stkViwControlls.isHidden = true
            delay(time: 0.3) {
                self.AssignPlayer(currentObj, completion: {
                    //currentObj.avPlayer.play()
                    self.btnPlayPause.isSelected = true
                })
                self.imgPost.isHidden = true
                self.viwPost.isHidden = false
                self.stkViwControlls.isHidden = false
            }
        } else {
            imgPost.imageFromURL(link: currentObj.Url, errorImage: postPlaceHolder, contentMode: .scaleAspectFill)
            imgPost.isHidden = false
            viwPost.isHidden = true
            stkViwControlls.isHidden = true
            currentObj.playerLayer.removeFromSuperlayer()
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
    
    func AssignPlayer(_ currentObj: Post, completion : (() -> Void)? = nil) {
        let playerItem = AVPlayerItem(url: URL(string: currentObj.Url)!)
        currentObj.avPlayer = AVPlayer(playerItem: playerItem)
        currentObj.playerLayer = AVPlayerLayer(player: currentObj.avPlayer)
        currentObj.playerLayer.videoGravity = .resizeAspectFill
        currentObj.playerLayer.layoutIfNeeded()
        currentObj.playerLayer.frame.size = self.viwPost.bounds.size
        self.viwPost.layoutIfNeeded()
        self.viwPost.layer.addSublayer(currentObj.playerLayer)
        if completion != nil {
            completion!()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: currentObj.avPlayer.currentItem)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        btnPlayPause.isSelected = false
        self.AssignPlayer(curObj, completion: nil)
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

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
        imgPost.isHidden = false
        viwPost.isHidden = true
        imgWaterMark.alpha = 0
    }

    var playerLayer : AVPlayerLayer!
    
    func ConfigureDatWithCell(_ currentObj: Post) {
        lblUserName.text = currentObj.UserName
        
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
    }
}

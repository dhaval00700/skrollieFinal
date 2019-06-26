//
//  HomeCollectionsView swift
//  SKROLLIE
//
//  Created by bin on 05/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class HomeCollectionsViewCell: UICollectionViewCell {

    @IBOutlet weak var imgUserPic: UIImageView!
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var lblTimeOfPhotos: UILabel!
    @IBOutlet weak var viewAllocColourDependOnTime: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        lblTimeOfPhotos.isHidden = true
    }
    
    func ConfigureCellWithData(_ data: Post) {
        imgBackGround.imageFromURL(link: data.Url, errorImage: UIImage(named: "img1"), contentMode: .scaleAspectFill)
        
        lblTimeOfPhotos.font = UIFont.Regular(ofSize: 12)
        
        if  !data.Isforever {
            lblTimeOfPhotos.text = "24 H O U R S  L E F T"
            viewAllocColourDependOnTime.backgroundColor = UIColor.init(red: 154/255, green: 191/255, blue: 34/255, alpha: 1.0)//9ABF22
        } else {
            lblTimeOfPhotos.text = "F O R E V E R"
            viewAllocColourDependOnTime.backgroundColor = UIColor.init(red: 245/255, green: 232/255, blue: 39/255, alpha: 1.0)//F5E827
        }
    }
    
}

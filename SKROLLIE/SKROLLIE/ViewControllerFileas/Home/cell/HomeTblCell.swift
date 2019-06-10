//
//  HomeTblCell.swift
//  SKROLLIE
//
//  Created by bin on 05/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class HomeTblCell: UITableViewCell
{
   
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var Collectionview: UICollectionView!
    
    @IBOutlet weak var viewOfUserProfileBackground: UIView!

    var collectionData = UserData()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        Collectionview.register(UINib(nibName: "HomeCollectionsViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionsViewCell")
        Collectionview.delegate = self
        Collectionview.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}


extension HomeTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return collectionData.arrPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionsViewCell", for: indexPath) as! HomeCollectionsViewCell
        
        let datas = collectionData.arrPost[indexPath.item]
        
        
        cell.imgBackGround!.sd_setImage(with: URL(string: datas.Url), placeholderImage: UIImage.init(named: "img1"), options: .highPriority) { (image, error, cacheType, url) in
            cell.imgBackGround.sd_setImage(with: URL(string: datas.Url), completed: nil)
        }
        
        cell.lblTimeOfPhotos.font = UIFont.Regular(ofSize: 12)
        
        if  indexPath.item % 2 == 0
        {
            cell.lblTimeOfPhotos.text = "24 H O U R S  L E F T"
        }
        else
        {
            cell.lblTimeOfPhotos.text = "F O R E V E R"
        }
        
        if  cell.lblTimeOfPhotos.text == "24 H O U R S  L E F T"
        {
            cell.viewAllocColourDependOnTime.backgroundColor = UIColor.init(red: 154/255, green: 191/255, blue: 34/255, alpha: 1.0)//9ABF22
        }
        else
        {
            cell.viewAllocColourDependOnTime.backgroundColor = UIColor.init(red: 245/255, green: 232/255, blue: 39/255, alpha: 1.0)//F5E827
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height - 10
        
        return CGSize(width: 220, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

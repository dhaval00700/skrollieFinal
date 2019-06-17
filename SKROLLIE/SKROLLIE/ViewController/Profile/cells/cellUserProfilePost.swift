//
//  cellUserProfilePost.swift
//  SKROLLIE
//
//  Created by brainstorm on 09/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class cellUserProfilePost: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var clvPost: UICollectionView!
    
    var collectionData = [Post]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clvPost.register(UINib(nibName: "HomeCollectionsViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionsViewCell")
        clvPost.delegate = self
        clvPost.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension cellUserProfilePost: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionsViewCell", for: indexPath) as! HomeCollectionsViewCell
        
        let datas = collectionData[indexPath.item]
        
        cell.imgBackGround.imageFromURL(link: datas.Url, errorImage: UIImage(named: "img1"), contentMode: .scaleAspectFill)
        
        cell.lblTimeOfPhotos.font = UIFont.Regular(ofSize: 12)
        
        if  !datas.Isforever {
            cell.lblTimeOfPhotos.text = "24 H O U R S  L E F T"
            cell.viewAllocColourDependOnTime.backgroundColor = UIColor.init(red: 154/255, green: 191/255, blue: 34/255, alpha: 1.0)//9ABF22
        } else {
            cell.lblTimeOfPhotos.text = "F O R E V E R"
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


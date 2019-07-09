//
//  HomeTblCell.swift
//  SKROLLIE
//
//  Created by bin on 05/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class HomeTblCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var Collectionview: UICollectionView!
    @IBOutlet weak var viewOfUserProfileBackground: UIView!

    // MARK: - Properties
    var collectionData = UserData()
    var viwMenu = UIView()

    // MARK: - LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        Collectionview.register(UINib(nibName: "HomeCollectionsViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionsViewCell")
        lblUserName.font = UIFont.Regular(ofSize: 16)
        Collectionview.delegate = self
        Collectionview.dataSource = self
    }
    
    func ConfigureCellWithData(_ data: UserData) {
        collectionData = data
        Collectionview.reloadData()
        lblUserName.text = collectionData.ProfileName
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
        let currentObj = collectionData.arrPost[indexPath.item]
        imgUser.imageFromURL(link: collectionData.ProfileImage, errorImage: #imageLiteral(resourceName: "img3"), contentMode: .scaleAspectFill)
        cell.ConfigureCellWithData(currentObj)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height - 10
        
        return CGSize(width: 220, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


extension HomeTblCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 1) {
            self.viwMenu.alpha = 0
        }
    }
    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate: Bool)
    {
        UIView.animate(withDuration: 3) {
            self.viwMenu.alpha = 1
        }
    }
}

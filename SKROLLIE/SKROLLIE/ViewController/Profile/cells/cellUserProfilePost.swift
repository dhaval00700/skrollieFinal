//
//  cellUserProfilePost.swift
//  SKROLLIE
//
//  Created by brainstorm on 09/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit


protocol cellUserProfilePostDelegate {
    func selectedPost(indexpath: IndexPath, arrPost: [Post])
}

class cellUserProfilePost: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var clvPost: UICollectionView!
    
    // MARK: - Properties
    var collectionData = [Post]()
    var delegate : cellUserProfilePostDelegate?
    var viwMenu = UIView()
    
    // MARK: - LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        clvPost.register(UINib(nibName: "HomeCollectionsViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionsViewCell")
        clvPost.delegate = self
        clvPost.dataSource = self
    }
    
    func ConfigureCellWithData(_ data: [Post]) {
        collectionData = data
        clvPost.reloadData()
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
        let currentObj = collectionData[indexPath.item]
        cell.ConfigureCellWithData(currentObj)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height - 10
        
        return CGSize(width: 220, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedPost(indexpath: indexPath, arrPost: collectionData)
    }
}

extension cellUserProfilePost: UIScrollViewDelegate {
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

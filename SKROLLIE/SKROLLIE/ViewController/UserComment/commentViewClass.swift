//
//  commentViewClass.swift
//  SKROLLIE
//
//  Created by brainstorm on 10/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import ScalingCarousel

class commentViewClass: BaseViewController
{
    @IBOutlet weak var lblTotalCmt: UILabel!
    @IBOutlet weak var viewEmoji: UIView!
    @IBOutlet weak var viewAllComment: UIView!
    @IBOutlet weak var viwUserListContainer: UIView!
    @IBOutlet weak var btnViewAllComment: UIButton!
    @IBOutlet weak var txtWriteReview: UITextField!
    @IBOutlet weak var collectionUserList: UICollectionView!
    @IBOutlet weak var tblForComment: UITableView!
    @IBOutlet weak var emojiPagerView: FSPagerView!
    @IBOutlet weak var constraintHightOfTblComment: NSLayoutConstraint!
    @IBOutlet var clvCarousel: ScalingCarouselView!
    
    var aryUserList = [String]()
    var aryImg = [String]()
    var isOwnProfile: Bool = false
    var arrPost = [Post]()
    var indexpath : IndexPath!
    
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.linear, .crossFading, .zoomOut, .depth, .linear, .overlap, .ferrisWheel, .invertedFerrisWheel, .coverFlow, .cubic]
    
    
    // MARK: - ViewMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        clvCarousel.deviceRotated()
    }
    
    private func setUpUI(){
        
        aryUserList = ["@happyCampper","@doggylover","@horedude"]
        aryImg = ["img5","img6","img5"]
        
        viwUserListContainer.layer.cornerRadius = 8.0
        
        if isOwnProfile {
            viewAllComment.isHidden = true
        }
        else{
            viewAllComment.isHidden = true
        }
        
        setupCollectionView()
        setupTableComment()
        setupEmogiPager()
    }
    
    private func setupCollectionView() {
        clvCarousel.register(UINib(nibName: "UserPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserPostCollectionViewCell")
        clvCarousel.delegate = self
        clvCarousel.dataSource = self
        clvCarousel.reloadData()
        delay(time: 2.0) {
            self.clvCarousel.scrollToItem(at: self.indexpath, at: .right, animated: false)
        }
        
        collectionUserList.register(UINib(nibName: "UserItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserItemCollectionViewCell")
        collectionUserList.delegate = self
        collectionUserList.dataSource = self
    }
    
    private func setupTableComment() {
        tblForComment.register(UINib(nibName: "AllCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllCommentsTableViewCell")
        tblForComment.dataSource = self
        tblForComment.delegate = self
        tblForComment.reloadData()
        tblForComment.layoutIfNeeded()
        constraintHightOfTblComment.constant = tblForComment.contentSize.height
    }
    
    private func setupEmogiPager() {
        emojiPagerView.delegate = self
        emojiPagerView.dataSource = self
        self.emojiPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.emojiPagerView.itemSize = CGSize(width: 50, height: 50)
        self.emojiPagerView.interitemSpacing = 8
        self.emojiPagerView.transformer = FSPagerViewTransformer(type:.linear)
    }
    
    // MARK: - Action
    @IBAction func btnDismiss(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - FSPagerViewDelegate,FSPagerViewDataSource
extension commentViewClass: FSPagerViewDelegate,FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return arrEmoji.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let currentEmoji = arrEmoji[index]
        
        cell.imageView?.image = currentEmoji
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension commentViewClass: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryImg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let imgOfUser = aryImg[indexPath.row]
        let Username = aryUserList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCommentsTableViewCell", for: indexPath) as! AllCommentsTableViewCell
        
        cell.imgUser.image = UIImage.init(named: imgOfUser)
        cell.lblUser.text = Username
        
        cell.tblSubComment.reloadData()
        cell.tblSubComment.layoutIfNeeded()
        cell.lctSubCommentTableHeight.constant = cell.tblSubComment.contentSize.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Extension For Scalling Carosouel
extension commentViewClass: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collectionUserList {
            return 3
        } else {
            return arrPost.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == collectionUserList {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "UserItemCollectionViewCell", for: indexPath) as!  UserItemCollectionViewCell
            
            return cell
        } else {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostCollectionViewCell", for: indexPath) as!  UserPostCollectionViewCell
            let currentObj = arrPost[indexPath.row]
            cell.ConfigureDatWithCell(currentObj)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

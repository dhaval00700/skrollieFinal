//
//  commentViewClass.swift
//  SKROLLIE
//
//  Created by brainstorm on 10/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var clvPost: UICollectionView!
    @IBOutlet weak var constraintHightOfTblComment: NSLayoutConstraint!
    
    var aryUserList = [String]()
    var aryImg = [String]()
    var isOwnProfile: Bool = false
    var CountOfUserProfile = Int()
    
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.linear,.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]
    
    
    // MARK: - ViewMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    func setUpUI(){
        
        tblForComment.register(UINib(nibName: "AllCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllCommentsTableViewCell")
        tblForComment.dataSource = self
        tblForComment.delegate = self
        collectionUserList.delegate = self
        collectionUserList.dataSource = self
        
        collectionUserList.register(UINib(nibName: "UserItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserItemCollectionViewCell")
        
        aryUserList = ["@happyCampper","@doggylover","@horedude"]
        aryImg = ["img5","img6","img5"]
        
        collectionUserList.reloadData()
        tblForComment.reloadData()
        emojiPagerView.delegate = self
        emojiPagerView.dataSource = self
        
        self.emojiPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.emojiPagerView.itemSize = CGSize.init(width: 60, height: 40)
        self.emojiPagerView.decelerationDistance = FSPagerView.automaticDistance
        let type = self.transformerTypes[0]
        self.emojiPagerView.transformer = FSPagerViewTransformer(type:type)
        
        viwUserListContainer.layer.cornerRadius = 8.0
        
        if isOwnProfile == true{
            viewAllComment.isHidden = false
        }
        else{
            viewAllComment.isHidden = true
        }
        
        tblForComment.reloadData()
        tblForComment.layoutIfNeeded()
        constraintHightOfTblComment.constant = tblForComment.contentSize.height
    }
    // MARK: - Action
    @IBAction func btnDismiss(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
}

extension commentViewClass: FSPagerViewDelegate,FSPagerViewDataSource{
    // MARK:- FSPagerViewDataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 10
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: "emoji1")
        cell.imageView?.contentMode = .center
        cell.imageView?.clipsToBounds = true
        
        cell._textLabel?.text = "+12"
        cell._textLabel?.contentMode = .topRight
        cell._textLabel?.backgroundColor = UIColor.red
        
        cell._textLabel?.backgroundColor = UIColor.red
        cell._textLabel?.textAlignment = .center
        cell._textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension commentViewClass: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "UserItemCollectionViewCell", for: indexPath) as!  UserItemCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = 110.0
        let height = 90.0
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - Comment Tableview Extention

extension commentViewClass: UITableViewDelegate,UITableViewDataSource,delegateSelectOfComment{
    
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

//
//  commentViewClass.swift
//  SKROLLIE
//
//  Created by brainstorm on 10/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import ScalingCarousel
import EasyTipView

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
    var tipView: EasyTipView?
    var tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 60, height: 0))
    
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
        setupEmogiPager()
        setupEasyTip()
    }
    
    private func setupEasyTip() {
        tipView?.removeFromSuperview()
        tipView = nil
        var pf = EasyTipView.Preferences()
        pf.drawing.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        pf.drawing.foregroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        pf.drawing.textAlignment = NSTextAlignment.center
        pf.drawing.arrowPosition = .bottom
        
        pf.animating.dismissTransform = CGAffineTransform(translationX: 0, y: 0)
        pf.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 0)
        pf.animating.showInitialAlpha = 0
        pf.animating.showDuration = 1
        pf.animating.dismissDuration = 1
        
        tipView = EasyTipView(contentView: self.tbl, preferences: pf, delegate: self)
        
        setupTableComment()
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
        
        tbl.register(UINib(nibName: "CommentItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentItemTableViewCell")
        tbl.dataSource = self
        tbl.delegate = self
        tbl.reloadData()
        tbl.layoutIfNeeded()
        tbl.frame = CGRect(x: 0, y: 0, width: 60, height: tbl.contentSize.height)
        
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
    
    @objc func handlePressGesture(gesture: UILongPressGestureRecognizer!) {
        let position = gesture.location(in: emojiPagerView.collectionView)
        let indexpath = self.emojiPagerView.collectionView.indexPathForItem(at: position)
        let cell = emojiPagerView.cellForItem(at: indexpath!.item)
        switch gesture.state {
        case .began:
            tipView?.show(forView: cell!.imageView!)
            break
        case .cancelled:
            
            break
        case .ended:
            
            break
        case .failed:

            break
        default:
            break
        }
    }
}


// MARK: - EasyTipViewDelegate
extension commentViewClass: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        DLog("\(tipView) did dismiss!")
    }
}

// MARK: - FSPagerViewDelegate,FSPagerViewDataSource
extension commentViewClass: FSPagerViewDelegate,FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return arrEmoji.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let currentEmoji = arrEmoji[ index]
        cell.imageView?.image = currentEmoji
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        cell.contentView.setBadge(text: "12", withOffsetFromTopRight: .zero, andColor: .red, andFilled: true, andFontSize: 8)
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handlePressGesture))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        cell.contentView.addGestureRecognizer(lpgr)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView) {
        setupEasyTip()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension commentViewClass: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
       return true
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension commentViewClass: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblForComment {
            return aryImg.count
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblForComment {
            let imgOfUser = aryImg[indexPath.row]
            let Username = aryUserList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllCommentsTableViewCell", for: indexPath) as! AllCommentsTableViewCell
            
            cell.imgUser.image = UIImage.init(named: imgOfUser)
            cell.lblUser.text = Username
            
            cell.tblSubComment.reloadData()
            cell.tblSubComment.layoutIfNeeded()
            cell.lctSubCommentTableHeight.constant = cell.tblSubComment.contentSize.height
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemTableViewCell", for: indexPath) as! CommentItemTableViewCell
            cell.lblUserComment.text = "smit"
            return cell
        }
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

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
    
    @IBOutlet weak var viwUnblockUser: UIView!
    @IBOutlet weak var viwComments: UIView!
    @IBOutlet weak var viwWriteReview: UIView!

    
    var aryUserList = [String]()
    var aryImg = [String]()
    var isOwnProfile: Bool = false
    var arrPost = [Post]()
    var indexpath : IndexPath!
    var tipView: EasyTipView?
    var tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 60, height: 0))
    var currentIndexForLike = 0
    
    var arrUserLike = [UserLike]()
    
    var userProfileDataObj: UserProfileModel!

    
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.linear, .crossFading, .zoomOut, .depth, .linear, .overlap, .ferrisWheel, .invertedFerrisWheel, .coverFlow, .cubic]
    
    
    // MARK: - ViewMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getAllLike()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        clvCarousel.deviceRotated()
    }
    
    private func setUpUI(){
        aryUserList = ["@happyCampper","@doggylover","@horedude"]
        aryImg = ["img5","img6","img5"]
        
        viwUserListContainer.layer.cornerRadius = 8.0
        
        viwComments.isHidden = true
        viwUnblockUser.isHidden = true
        viwWriteReview.isHidden = true
        
        if isOwnProfile {
            viwUnblockUser.isHidden = false
            viwComments.isHidden = false
            viwComments.isHidden = true

        }
        else{
            viewAllComment.isHidden = false
            viwWriteReview.isHidden = true

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
        currentIndexForLike = self.indexpath.row
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
    
    var selectedToolTipIndex = 0
    
    @objc func handlePressGesture(gesture: UILongPressGestureRecognizer!) {
        let position = gesture.location(in: emojiPagerView.collectionView)
        let indexpath = self.emojiPagerView.collectionView.indexPathForItem(at: position)
        let cell = emojiPagerView.cellForItem(at: indexpath!.item)
        
        switch gesture.state {
        case .began:
            selectedToolTipIndex = indexpath!.item
            tipView?.show(forView: cell!.imageView!)
            tbl.reloadData()
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
        return arrUserLike.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let currentEmoji = arrUserLike[ index]
        cell.imageView?.image = currentEmoji.likeEmoji
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        cell.contentView.setBadge(text: currentEmoji.TotalLike, withOffsetFromTopRight: .zero, andColor: .red, andFilled: true, andFontSize: 8)
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handlePressGesture))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        cell.contentView.addGestureRecognizer(lpgr)
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if !isOwnProfile {
            let currentEmoji = arrEmoji[ index]
            likeUser(emojiLike: Int(returnEmojiNumber(img: currentEmoji))!)
        }
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
            return arrUserLike.count > 0 ? arrUserLike[selectedToolTipIndex].arrLikeUsers.count : 0
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
            let currentObj = arrUserLike[selectedToolTipIndex].arrLikeUsers[indexPath.row]
            cell.imgUser.imageFromURL(link: prefixDataUrl + currentObj.attachimage, errorImage: profilePlaceHolder, contentMode: .scaleAspectFill)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblForComment {
           return UITableView.automaticDimension
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblForComment {
           return UITableView.automaticDimension
        }
        return 70
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
            cell.emoji1.isHidden = false
            cell.emoji2.isHidden = false
            if isOwnProfile {
                cell.emoji1.isHidden = true
                cell.emoji2.isHidden = true
                cell.imgUserProfile.imageFromURL(link: userProfileDataObj.image, errorImage: postPlaceHolder, contentMode: .scaleAspectFill)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

//MARK: - Webservice Call
extension commentViewClass {
    
    private func likeUser(emojiLike:Int) {
        
        let param = ParameterRequest()
        let obj = arrPost[currentIndexForLike]
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserData().UserId)
        param.addParameter(key: ParameterRequest.idPost, value: obj.Postid)
        param.addParameter(key: ParameterRequest.Emoji, value: emojiLike)

        _ = APIClient.LikePostByUser(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
               
            }
        }
    }
    
    private func getAllLike() {
        let obj = arrPost[currentIndexForLike]
        _ = APIClient.GetAllLike(idPost: obj.Postid) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.arrUserLike = UserLike.getArray(data: response["response"] as? [[String : Any]] ?? [[String : Any]]())
            }
            self.tbl.reloadData()
            self.tbl.layoutIfNeeded()
            self.tbl.frame = CGRect(x: 0, y: 0, width: 60, height: self.tbl.contentSize.height)
            self.emojiPagerView.reloadData()
        }
    }
}


extension commentViewClass : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
            var visibleRect = CGRect()
            
            visibleRect.origin = clvCarousel.contentOffset
            visibleRect.size = clvCarousel.bounds.size
            
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
            guard let indexPath = clvCarousel.indexPathForItem(at: visiblePoint) else { return }
            currentIndexForLike = indexPath.row
            getAllLike()
       
       
    }
}

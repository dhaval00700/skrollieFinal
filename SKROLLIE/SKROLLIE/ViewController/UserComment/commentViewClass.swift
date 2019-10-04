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
import AudioToolbox

protocol UpdateListDelegate {
    func ViewReload()
}

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
    @IBOutlet weak var clvCarousel: ScalingCarouselView!
    
    @IBOutlet weak var viwUnblockUser: UIView!
    @IBOutlet weak var viwComments: UIView!
    @IBOutlet weak var viwWriteReview: UIView!
    @IBOutlet weak var mainScroll: UIScrollView!

    @IBOutlet weak var viwReply: UIView!
    @IBOutlet weak var lblReplyuserName: UILabel!

    var isOwnProfile: Bool = false
    var arrPost = [Post]()
    var indexpath : IndexPath!
    var tipView: EasyTipView?
    var tbl = UITableView(frame: CGRect(x: 0, y: 0, width: 60, height: 0))
    var currentIndexForLike = 0
    
    var arrUserLike = [UserLike]()
    var arrUserUnblock = [UserUnblock]()

    var userProfileDataObj: UserProfileModel!
    var selectedPostuserData = UserData()
    var selectedEmojiButton: UIButton!
    
    var subRply = false
    var subUserComment = UserComment()
    fileprivate var moreDropDown: DropDown!
    
    var selectedToolTipIndex = 0
    var arrUserComment = [UserComment]()
    
    var selectedEmojiIndex = 0
    var selectedEmoji1 = -1
    var selectedEmoji2 = -1
    
    var pf = EasyTipView.Preferences()
    var delegate: UpdateListDelegate?
    
    
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.linear, .crossFading, .zoomOut, .depth, .linear, .overlap, .ferrisWheel, .invertedFerrisWheel, .coverFlow, .cubic]
    
    
    // MARK: - ViewMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        updatePostById()
        getAllLike()
        getAllComment()
        getUnblockPost()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        clvCarousel.deviceRotated()
    }
    
    private func setUpUI() {
        txtWriteReview.addLeftPadding(padding: 10.0)
        viwWriteReview.addCornerRadius(8.0)
        viwWriteReview.clipsToBounds = true
        viwReply.addCornerRadius(8.0)
        viwReply.clipsToBounds = true
        
        viwUserListContainer.layer.cornerRadius = 8.0
        
        viwComments.isHidden = true
        viwUnblockUser.isHidden = true
        viwWriteReview.isHidden = true
        viewAllComment.isHidden = true
        viwReply.isHidden = true

        if isOwnProfile {
            viwUnblockUser.isHidden = false
            viwComments.isHidden = false
            viewAllComment.isHidden = true
            viwWriteReview.isHidden = false
        }
        
        tblForComment.register(UINib(nibName: "AllCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllCommentsTableViewCell")
        tblForComment.dataSource = self
        tblForComment.delegate = self
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.cancelsTouchesInView = false
        clvCarousel.addGestureRecognizer(swipeRight)
        
        setupCollectionView()
        setupEmogiPager()
        setCommentView()
        setupEasyTip()
    }
    
    private func setupEasyTip() {
        tipView?.removeFromSuperview()
        tipView = nil
        
        pf.drawing.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        pf.drawing.foregroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        pf.drawing.textAlignment = NSTextAlignment.center
        pf.drawing.arrowPosition = .bottom
        
        pf.animating.dismissTransform = CGAffineTransform(translationX: 0, y: 0)
        pf.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 0)
        pf.animating.showInitialAlpha = 0
        pf.animating.showDuration = 1
        pf.animating.dismissDuration = 1
        
        setupTableComment()
        tipView = EasyTipView(contentView: self.tbl, preferences: pf, delegate: self)
    }
    
    private func setupCollectionView() {
        clvCarousel.register(UINib(nibName: "UserPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserPostCollectionViewCell")
        clvCarousel.delegate = self
        clvCarousel.dataSource = self
        clvCarousel.reloadData()
        currentIndexForLike = self.indexpath.row
        let object = arrPost[currentIndexForLike]
        if object.IsUnBlockPost && !isOwnProfile {
            self.viewAllComment.isHidden = false
            self.viwWriteReview.isHidden = false
        }
        else if object.Emoji1.isEmpty && object.Emoji2.isEmpty && !isOwnProfile  {
            self.viwWriteReview.isHidden = false
        }
        
        delay(time: 1.0) {
            self.clvCarousel.scrollToItem(at: self.indexpath, at: .right, animated: false)
        }
        
        collectionUserList.register(UINib(nibName: "UserItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserItemCollectionViewCell")
        collectionUserList.delegate = self
        collectionUserList.dataSource = self
    }
    
    private func setDropDown(btn:UIButton) {
        moreDropDown = DropDown()
        
        moreDropDown.anchorView = btn
        if isOwnProfile {
            moreDropDown.dataSource = ["Report", "Delete"]
        } else {
            moreDropDown.dataSource = ["Report"]
        }
        
        moreDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Report" {
                self.reportPost(postId: self.arrPost[btn.tag].Postid)
            } else if item == "Delete" {
                self.deletePost(postId: self.arrPost[btn.tag].Postid)
            }
        }
        moreDropDown.backgroundColor = .clear
       // moreDropDown.bottomOffset = CGPoint(x: -moreDropDown.frame.width, y: -100)
        
        moreDropDown.width = 110
    }
    
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
                self.dismiss(animated: true, completion: nil)
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func setCommentView() {
       let object = arrPost[currentIndexForLike]
        if object.Emoji1.isEmpty && object.Emoji2.isEmpty {
            viwComments.isHidden = false
        }
    }
    
    func resetDataWhenScroll() {
         selectedEmojiIndex = 0
         selectedEmoji1 = -1
         selectedEmoji2 = -1
        self.arrUserComment.removeAll()
        self.viwWriteReview.isHidden = true

        updatePostById()
        getAllLike()
        getAllComment()
        setCommentView()
        getUnblockPost()
        
        let cell = clvCarousel.cellForItem(at: IndexPath(item: (currentIndexForLike - 1), section: 0)) as? UserPostCollectionViewCell
        if cell != nil {
            cell!.viwGray.isHidden = false
        }
        
        let object = arrPost[currentIndexForLike]
        
        if object.IsUnBlockPost && !isOwnProfile {
            self.viewAllComment.isHidden = false
            self.viwWriteReview.isHidden = false
        } else if object.Emoji1.isEmpty && object.Emoji2.isEmpty && !isOwnProfile  {
            self.viwWriteReview.isHidden = false
        }
    }
    
    private func setupTableComment() {
        
        tbl.register(UINib(nibName: "LikeUserItemTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeUserItemTableViewCell")
        tbl.dataSource = self
        tbl.delegate = self
        
        
    }
    
    private func setupEmogiPager() {
        emojiPagerView.delegate = self
        emojiPagerView.dataSource = self
        self.emojiPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.emojiPagerView.itemSize = CGSize(width: 50, height: 50)
        self.emojiPagerView.interitemSpacing = 8
        self.emojiPagerView.transformer = FSPagerViewTransformer(type:.linear)
    }
    
    
    func setEmojis() {
        let cell = clvCarousel.cellForItem(at: IndexPath(item: currentIndexForLike, section: 0)) as! UserPostCollectionViewCell
        let curretObj = arrPost[currentIndexForLike]
        let currentEmoji = arrUserLike[selectedEmojiIndex]
        if selectedEmojiButton == cell.emoji1 {
             cell.emoji1.setImage(currentEmoji.likeEmoji, for: .normal)
            selectedEmoji1 = currentEmoji.Emoji
        }
        
        if selectedEmojiButton == cell.emoji2 {
            cell.emoji2.setImage(currentEmoji.likeEmoji, for: .normal)
            selectedEmoji2 = currentEmoji.Emoji
        }
        
        if selectedEmoji1 != -1 && selectedEmoji2 != -1 {
            if (selectedEmoji1 == Int(curretObj.Emoji1)) && (selectedEmoji2 == Int(curretObj.Emoji2)) { // API calling
                unlockComment()
            } else { // vibrate
                cell.emoji1.setImage(UIImage(named: "blankHappy"), for: .normal)
                cell.emoji2.setImage(UIImage(named: "blankSad"), for: .normal)
                selectedEmojiButton = nil
                selectedEmoji1 = -1
                selectedEmoji2 = -1
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
       selectedEmojiButton = nil
        clvCarousel.reloadData()
    }
    
    // MARK: - Action
    @IBAction func btnDismiss(_ sender: Any){
        delegate?.ViewReload()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTapEmoji1(_ sender: UIButton) {
         let cell = clvCarousel.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! UserPostCollectionViewCell
        cell.emoji1.isSelected = true
        selectedEmojiButton = sender
        clvCarousel.reloadData()
    }
    
    @IBAction func btnTapEmoji2(_ sender: UIButton) {
         let cell = clvCarousel.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! UserPostCollectionViewCell
        cell.emoji2.isSelected = true
        selectedEmojiButton = sender
        clvCarousel.reloadData()
    }
    
    @IBAction func tapAllCommentClick(_ sender: UIButton) {
        let vc = AllCommentViewController.instantiate(fromAppStoryboard: .Main)
        vc.postId = arrPost[currentIndexForLike].Postid
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSendComment(_ sender: UIButton) {
        self.view.endEditing(true)
        if !txtWriteReview.text!.isEmpty {
            if viwReply.isHidden == false && !subRply {
                let obj = arrUserComment[sender.tag]
                sendComment(idComment: obj.idComment)
            } else if viwReply.isHidden == false && subRply {
                sendComment(idComment: subUserComment.idComment)
            }  else {
                sendComment(idComment: "")
            }
        }
    }
    
    @IBAction func btnCommentReply(_ sender: UIButton) {
        self.viwReply.isHidden = false
        let obj = arrUserComment[sender.tag]
        lblReplyuserName.text = "Replying to " + obj.UserObj.username
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
         self.view.endEditing(true)
        viwReply.isHidden = true
        txtWriteReview.text = ""
        self.subRply = false
    }
    
    @IBAction func btnMore(_ sender: UIButton) {
        moreDropDown.show()
    }
    
    @objc func handlePressGesture(gesture: UILongPressGestureRecognizer!) {
        let position = gesture.location(in: emojiPagerView.collectionView)
        let indexpath = self.emojiPagerView.collectionView.indexPathForItem(at: position)
        let cell = emojiPagerView.cellForItem(at: indexpath!.item)
        
        switch gesture.state {
        case .began:
            selectedToolTipIndex = indexpath!.item

            if arrUserLike[selectedToolTipIndex].arrLikeUsers.count > 0 {
                tbl.reloadData()
                tbl.layoutIfNeeded()
                tbl.frame = CGRect(x: 0, y: 0, width: 60, height: tbl.contentSize.height)
                tipView = nil
                tipView = EasyTipView(contentView: self.tbl, preferences: pf, delegate: self)
                tipView?.show(forView: cell!.imageView!)
            }
            
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
    
    @objc func onBtnPlayPause(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.clvCarousel)
        let indexPath = self.clvCarousel.indexPathForItem(at: buttonPosition)
        if indexPath != nil {
            let cell = clvCarousel.cellForItem(at: indexPath!) as! UserPostCollectionViewCell
            let currentObj = arrPost[sender.tag]
            if cell.btnPlayPause.isSelected  {
                currentObj.avPlayer.pause()
                cell.btnPlayPause.isSelected = false
            } else {
                currentObj.avPlayer.play()
                cell.btnPlayPause.isSelected = true
            }
        }
    }
    
    @objc func onBtnMute(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.clvCarousel)
        let indexPath = self.clvCarousel.indexPathForItem(at: buttonPosition)
        if indexPath != nil {
            let cell = clvCarousel.cellForItem(at: indexPath!) as! UserPostCollectionViewCell
            let currentObj = arrPost[sender.tag]
            cell.btnMuteControll.isSelected = !cell.btnMuteControll.isSelected
            currentObj.avPlayer.isMuted = !currentObj.avPlayer.isMuted
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
        if isOwnProfile {
            cell.contentView.setBadge(text: currentEmoji.TotalLike, withOffsetFromTopRight: .zero, andColor: .red, andFilled: true, andFontSize: 8)
            let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handlePressGesture))
            lpgr.minimumPressDuration = 0.5
            lpgr.delaysTouchesBegan = true
            cell.contentView.addGestureRecognizer(lpgr)
        }
       
        
        return cell
    }
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if !isOwnProfile {
            selectedEmojiIndex = index

            if selectedEmojiButton != nil {
                setEmojis()
            }
            else {
                let currentEmoji = arrEmoji[ index]
                likeUser(emojiLike: Int(returnEmojiNumber(img: currentEmoji))!)
                let obj = arrPost[currentIndexForLike]
                obj.LikeEmoji = "\(Int(returnEmojiNumber(img: currentEmoji))!)"
                self.arrPost.remove(at: self.currentIndexForLike)
                self.arrPost.insert(obj, at: self.currentIndexForLike)
                self.clvCarousel.reloadData()
            }
            
        }
    }
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView) {
        setupEasyTip()
        
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        tipView?.removeFromSuperview()
        tipView = nil
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        
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
            return arrUserComment.count > 3 ? 3 : arrUserComment.count
        } else {
            return arrUserLike.count > 0 ? arrUserLike[selectedToolTipIndex].arrLikeUsers.count : 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblForComment {
            let currentObj = arrUserComment[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllCommentsTableViewCell", for: indexPath) as! AllCommentsTableViewCell
            
            cell.imgUser.imageFromURL(link: currentObj.UserObj.image, errorImage: profilePlaceHolder, contentMode: .scaleAspectFill)
            cell.lblUser.text = currentObj.UserObj.username
            cell.lblUserComment.text = currentObj.Comment
            cell.arrReplyComment = currentObj.LstReplayComment
            cell.reloadData()
            self.tblForComment.layoutIfNeeded()
            self.constraintHightOfTblComment.constant = self.tblForComment.contentSize.height
            cell.dalegate = self

            cell.btnReply.tag = indexPath.row
            cell.btnReply.addTarget(self, action: #selector(btnCommentReply(_:)), for: .touchUpInside)
            
            return cell
        } else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "LikeUserItemTableViewCell", for: indexPath) as! LikeUserItemTableViewCell
            let currentObj = arrUserLike[selectedToolTipIndex].arrLikeUsers[indexPath.row]
            cell.imgUserProfile.imageFromURL(link: prefixDataUrl + currentObj.attachimage, errorImage: profilePlaceHolder, contentMode: .scaleAspectFill)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblForComment {
           return UITableView.automaticDimension
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblForComment {
           return UITableView.automaticDimension
        }
        return 60
    }
}

//MARK: - Extension For Scalling Carosouel
extension commentViewClass: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collectionUserList {
            return arrUserUnblock.count
        } else {
            return arrPost.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == collectionUserList {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "UserItemCollectionViewCell", for: indexPath) as!  UserItemCollectionViewCell
            let currentObj = arrUserUnblock[indexPath.row]
            cell.lblUserName.text = currentObj.UserObj.username
            cell.imgUserProfile.imageFromURL(link: currentObj.UserObj.image, errorImage: postPlaceHolder, contentMode: .scaleAspectFill)
            
            return cell
        } else {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostCollectionViewCell", for: indexPath) as!  UserPostCollectionViewCell
            let currentObj = arrPost[indexPath.row]
            cell.ConfigureDatWithCell(currentObj)
            cell.emoji1.isHidden = false
            cell.emoji2.isHidden = false
            if !currentObj.IsAccountVerify {
                cell.imgAccountVerified.isHidden = true
            } else {
                cell.imgAccountVerified.isHidden = false
            }
            self.setDropDown(btn: cell.btnMore)
            
            if isOwnProfile {
                cell.emoji1.isHidden = true
                cell.emoji2.isHidden = true
                cell.imgUserProfile.imageFromURL(link: userProfileDataObj.image, errorImage: postPlaceHolder, contentMode: .scaleAspectFill)
            } else {
                if currentObj.IsUnBlockPost {
                    cell.emoji1.isHidden = true
                    cell.emoji2.isHidden = true
                } else if currentObj.Emoji1.isEmpty && currentObj.Emoji2.isEmpty {
                    cell.emoji1.isHidden = true
                    cell.emoji2.isHidden = true
                }
                
                cell.imgUserProfile.imageFromURL(link: selectedPostuserData.ProfileImage, errorImage: postPlaceHolder, contentMode: .scaleAspectFill)
            }
            
            cell.btnPlayPause.tag = indexPath.item
            cell.btnPlayPause.addTarget(self, action: #selector(onBtnPlayPause), for: .touchUpInside)
            
            cell.btnMuteControll.tag = indexPath.item
            cell.btnMuteControll.addTarget(self, action: #selector(onBtnMute), for: .touchUpInside)
            
            cell.btnMore.tag = indexPath.row
            cell.btnMore.addTarget(self, action: #selector(btnMore(_:)), for: .touchUpInside)
            
            if !cell.emoji1.isHidden {
                cell.emoji1.tag = indexPath.row
                cell.emoji1.addTarget(self, action: #selector(btnTapEmoji1(_:)), for: .touchUpInside)
            }
            
            if !cell.emoji2.isHidden {
                cell.emoji2.tag = indexPath.row
                cell.emoji2.addTarget(self, action: #selector(btnTapEmoji2(_:)), for: .touchUpInside)
                
            }
            
            cell.emoji1.isHighlighted = false
            cell.emoji2.isHighlighted = false

            if cell.emoji1.imageView?.image == UIImage(named: "blankHappy") && !cell.emoji1.isSelected {
               cell.emoji1.isHighlighted = true
            }
            
            if cell.emoji2.imageView?.image == UIImage(named: "blankSad") && !cell.emoji2.isSelected {
                cell.emoji2.isHighlighted = true
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == collectionUserList {
            let obj: userProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "userProfileClass") as! userProfileClass
            obj.userId = arrUserUnblock[indexPath.row].UserObj.id
            obj.isFriend = true
            obj.isThisDetail = true

            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}

//MARK: - Webservice Call
extension commentViewClass {
    
    private func likeUser(emojiLike:Int) {
         self.showNetworkIndicator()
        
        let param = ParameterRequest()
        let obj = arrPost[currentIndexForLike]
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserProfileData().id)
        param.addParameter(key: ParameterRequest.idPost, value: obj.Postid)
        param.addParameter(key: ParameterRequest.Emoji, value: emojiLike)

        _ = APIClient.LikePostByUser(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                
               obj.LikeEmoji = "\(emojiLike)"
                self.arrPost.remove(at: self.currentIndexForLike)
                self.arrPost.insert(obj, at: self.currentIndexForLike)
                self.clvCarousel.reloadData()
            }
            self.hideNewtworkIndicator()
        }
    }
    
    private func updatePostById() {
        let param = ParameterRequest()
        let obj = arrPost[currentIndexForLike]
        param.addParameter(key: ParameterRequest.id, value: obj.Postid)
        param.addParameter(key: ParameterRequest.IsWatch, value: true)
        
        updatePostById(parameters: param.parameters) { (flag) in
            DLog("ParameterRequest.id", obj.Postid)
        }
    }
    
    private func getAllLike() {
        let obj = arrPost[currentIndexForLike]
        _ = APIClient.GetAllLike(idPost: obj.Postid) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            self.arrUserLike.removeAll()
            if responseData.success {
                self.arrUserLike = UserLike.getArray(data: response["response"] as? [[String : Any]] ?? [[String : Any]]())
            }
            self.tbl.reloadData()
            self.tbl.layoutIfNeeded()
            self.tbl.frame = CGRect(x: 0, y: 0, width: 60, height: self.tbl.contentSize.height)
            self.emojiPagerView.reloadData()
        }
    }
    
    private func unlockComment() {
        
        let param = ParameterRequest()
        let obj = arrPost[currentIndexForLike]
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserProfileData().id)
        param.addParameter(key: ParameterRequest.PostId, value: obj.Postid)
        
        _ = APIClient.UnlockComment(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.viewAllComment.isHidden = false
                self.viwComments.isHidden = false
                self.viwWriteReview.isHidden = false
                self.getUnblockPost()
                self.getAllComment()
            }
        }
    }
    
    private func getAllComment() {
        
        let obj = arrPost[currentIndexForLike]
        _ = APIClient.GetAllComment(idPost: obj.Postid) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            self.arrUserComment.removeAll()
            if responseData.success {
                
                self.arrUserComment = UserComment.getArray(data: response["data"] as? [[String : Any]] ?? [[String : Any]]())
            }
            
            if self.arrUserComment.count > 3 {
                self.viwComments.isHidden = false
                self.viewAllComment.isHidden = false
                self.lblTotalCmt.text = "\(self.arrUserComment.count)"
            } else if self.arrUserComment.isEmpty {
                self.viewAllComment.isHidden = true
                self.viwComments.isHidden = true
            } else {
                self.viewAllComment.isHidden = true
                self.viwComments.isHidden = false

            }
            
            self.tblForComment.reloadData()
            self.tblForComment.layoutIfNeeded()
            self.constraintHightOfTblComment.constant = self.tblForComment.contentSize.height
            
            self.tblForComment.reloadData()
            self.tblForComment.layoutIfNeeded()
            self.constraintHightOfTblComment.constant = self.tblForComment.contentSize.height
           
        }
    }
    
    private func sendComment(idComment:String) {
        self.showNetworkIndicator()
        
        let param = ParameterRequest()
        let obj = arrPost[currentIndexForLike]
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserProfileData().id)
        param.addParameter(key: ParameterRequest.idPost, value: obj.Postid)
        param.addParameter(key: ParameterRequest.Comment, value: txtWriteReview.text!)
        param.addParameter(key: ParameterRequest.idComment, value: idComment)
        
        _ = APIClient.SavePostComment(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.txtWriteReview.text = ""
                self.viwReply.isHidden = true
                self.subRply = false
                self.getAllComment()
            }
            self.hideNewtworkIndicator()
        }
    }
    
    private func getUnblockPost() {
        
        let obj = arrPost[currentIndexForLike]
        _ = APIClient.GetUnblockPost(idPost: obj.Postid) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            self.arrUserComment.removeAll()
            self.arrUserUnblock.removeAll()
            if responseData.success {
                self.arrUserUnblock = UserUnblock.getArray(data: response["data"] as? [[String : Any]] ?? [[String : Any]]())
            }
            
            if self.arrUserUnblock.count > 0 && self.isOwnProfile {
                self.viwUnblockUser.isHidden = false
            } else {
                self.viwUnblockUser.isHidden = true
            }
            
        
            
            self.collectionUserList.reloadData()
            
        }
    }

    private func deletePost(postId:String) {
        
        _ = APIClient.DeletePost(idPost: postId) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            self.arrUserComment.removeAll()
            self.arrUserUnblock.removeAll()
            if responseData.success {
                self.arrPost.remove(at: self.currentIndexForLike)
                self.clvCarousel.reloadData()
            }
        }
    }
    
    private func reportPost(postId:String) {
        
        let param = ParameterRequest()
        param.addParameter(key: ParameterRequest.ReportedByUserId, value: AppPrefsManager.shared.getUserProfileData().id)
        param.addParameter(key: ParameterRequest.ReportedPostId, value: postId)
       
        _ = APIClient.ReportPost(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                Utility.showMessageAlert(title: "Alert", andMessage: responseData.message, withOkButtonTitle: "OK")
            }
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
            resetDataWhenScroll()
        
    }
   
}


extension commentViewClass: AllCommentsTableViewCellDelegate {
    func selectedReply(selectedObj: UserComment) {
        
        self.viwReply.isHidden = false
        self.viwWriteReview.isHidden = false
        
        lblReplyuserName.text = "Replying to " + selectedObj.UserObj.username
        
        subRply = true
        subUserComment = selectedObj
    }
}

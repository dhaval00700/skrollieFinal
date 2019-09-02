//
//  userProfileClass.swift
//  SKROLLIE
//
//  Created by brainstorm on 09/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import MobileCoreServices

class userProfileClass: BaseViewController
{
    // MARK: - Outlet
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var imgUserPic: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUserTag: UILabel!
    @IBOutlet weak var imgUserTag: UIImageView!
    @IBOutlet weak var btnCOnnect: UIButton!
    @IBOutlet weak var txvDesc: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnForever: UIButton!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var lblForever: UILabel!
    @IBOutlet weak var viwProgressBar: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lctTxvDescHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSearchOrBack: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    // MARK: - Properties
    var arrData = [GetPostData]()
    var userId = AppPrefsManager.shared.getUserData().UserId
    var isFriend = false
    var isThisDetail = false
    fileprivate var moreDropDown: DropDown!
    private var userProfileData: UserProfileModel!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for tempObj in arrData {
            for tempData in tempObj.arrPostData {
                for temp in tempData {
                    temp.timer.invalidate()
                }
            }
        }
    }
    
    // MARK: - Methods
    private func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(onProgress), name: PROGRESS_NOTIFICATION_KEY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(afterSavePost), name: REFRESH_NOTIFICATION_KEY, object: nil)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "ic_nav_hedder"),
                                                                    for: .default)
    
        lblTitle.font = UIFont.Regular(ofSize: 20)
        lblUsername.font = UIFont.Regular(ofSize: 16)
        lblUserTag.font = UIFont.Regular(ofSize: 16)
        btnCOnnect.titleLabel?.font =  UIFont.Regular(ofSize: 16)
        btnCOnnect.addCornerRadius(8)
        btnToday.addCornerRadius(8)
        btnForever.addCornerRadius(8)
        lblToday.font = UIFont.Bold(ofSize: 15)
        lblForever.font = UIFont.Bold(ofSize: 14)
        lblNoData.isHidden = false
        imgUserTag.image = #imageLiteral(resourceName: "ic_shield").tintWithColor(#colorLiteral(red: 0.2374413013, green: 0.1816716492, blue: 0.3331321776, alpha: 1))
        
        tableview.register(UINib(nibName: "cellUserProfilePost", bundle: nil), forCellReuseIdentifier: "cellUserProfilePost")
        tableview.register(UINib(nibName: "CellUserProfileSectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CellUserProfileSectionTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        viwProgressBar.isHidden = true
        btnCOnnect.isHidden = true
        
        progressBar.layer.cornerRadius = 8
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers!.first!.cornerRadius = 8
        progressBar.subviews.first!.clipsToBounds = true
        btnEdit.isHidden = true

        txvDesc.isEditable = false
        txvDesc.delegate = self
        lctTxvDescHeight.constant = 0
        
        btnEdit.setImage(UIImage(named: "Edit")?.tintWithColor(#colorLiteral(red: 0.2374413013, green: 0.1816716492, blue: 0.3331321776, alpha: 1)), for: .normal)
        imgUserTag.isHidden = true
        
        getUserProfileData(userId: userId, complation: { (flg, userProfileModel) in
            if flg {
                self.userProfileData = userProfileModel
                self.setData()
                self.setDropDown()
            }
        })
        self.viewBottom.isHidden = true
        UIView.animate(withDuration: 1) {
            self.viewBottom.alpha = 0
        }
        getForeverPostByUserId()
        
        if isThisDetail {
            btnSearchOrBack.setImage(#imageLiteral(resourceName: "iconBack"), for: .normal)
            btnSetting.isHidden = true
            viewMenu.isHidden = true
        } else {
            btnSearchOrBack.setImage(#imageLiteral(resourceName: "iconSearch"), for: .normal)
            btnSetting.isHidden = false
            viewMenu.isHidden = false
        }
    }
    
    private func setDropDown() {
        moreDropDown = DropDown()
        
        moreDropDown.anchorView = btnMore
        if isFriend {
            moreDropDown.dataSource = ["Disconnect", "Report", "Block"]
        } else {
            moreDropDown.dataSource = ["Report", "Block"]
        }
        moreDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Block" {
                self.updateStatus(userId: self.userProfileData.id, isBlock: true, completion: { (flg) in
                    if flg {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            } else if item == "Report" {
                self.reportUser(userId: self.userProfileData.id)
            } else if item == "Disconnect"  {
                self.unFriendUser(userId: self.userProfileData.id, completion: { (flg) in
                    if flg {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
        moreDropDown.backgroundColor = .clear
        moreDropDown.bottomOffset = CGPoint(x: -moreDropDown.frame.width, y: -100)
        
        moreDropDown.width = 110
    }
    
    private func setData() {
        if userProfileData.IsAccountVerify == AccountVerifyStatus.zero || userProfileData.IsAccountVerify == AccountVerifyStatus.one {
            imgUserTag.isHidden = true
        } else {
            imgUserTag.isHidden = false
        }
        if userId == AppPrefsManager.shared.getUserData().UserId || isFriend {
            btnCOnnect.isHidden = true
        } else {
            btnCOnnect.isHidden = false
        }
        
        if userId == AppPrefsManager.shared.getUserData().UserId {
            btnMore.isHidden = true
            btnEdit.isHidden = false
        } else {
            btnMore.isHidden = false
            btnEdit.isHidden = true
        }
        
        imgUserPic.imageFromURL(link: userProfileData.image, errorImage: profilePlaceHolder, contentMode: .scaleAspectFill, isCache: true)
        btnToday.setTitle(userProfileData.TotalTodayPost, for: .normal)
        btnForever.setTitle(userProfileData.TotalForeverPost, for: .normal)
        lblUserTag.text = "@" + userProfileData.username
        txvDesc.text = userProfileData.description
        txvDesc.layoutIfNeeded()
        lctTxvDescHeight.constant = txvDesc.contentSize.height
        lblUsername.text = userProfileData.ProfileName
        self.viewBottom.isHidden = false
        UIView.animate(withDuration: 1) {
            self.viewBottom.alpha = 1
        }
    }
    
    // MARK: - Actions
    @objc func onProgress(_ notificaton: NSNotification) {
        viwProgressBar.isHidden = false
        guard let userInfo = notificaton.userInfo,
            let obj = userInfo as? [String: Any] else { return }
        let uploadProgress = obj["uploadProgress"] as! Float
        progressBar.progress = uploadProgress
        if uploadProgress == 1.0 {
            viwProgressBar.isHidden = true
        }
    }
    
    @objc func afterSavePost(_ notificaton: NSNotification) {
        delay(time: 1.0) {
            self.getForeverPostByUserId()
            self.getUserProfileData(userId: self.userId, complation: { (flg, userProfileModel) in
                if flg {
                    self.userProfileData = userProfileModel
                    self.setData()
                }
            })
        }
    }
    
    @IBAction func btnSetting(_ sender: UIButton) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "SettingVc") as! UINavigationController
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated:true, completion: nil)
    }
    
    @IBAction func btnUserProfile(_ sender: UIButton) {
        goToHomePage()
    }
    
    @IBAction func btnUserPicture(_ sender: UIButton) {
    }
    
    @IBAction func btnFrndList(_ sender: UIButton) {
        let navVc = FriendListViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(navVc, animated: true)
    }
    
    @IBAction func btnConnect(_ sender: UIButton) {
        createFriend(userId: userId) { (flg) in
            if flg {
                self.btnCOnnect.isHidden = true
            }
        }
    }
    
    @IBAction func btnMore(_ sender: UIButton) {
        moreDropDown.show()
    }
    
    @IBAction func onBtnToday(_ sender: UIButton) {
        let indexToday = arrData.firstIndex { (obj) -> Bool in
            return obj.sectionName == TwentyFourHourStr
        }
        if indexToday != nil {
            tableview.scrollToRow(at: IndexPath(row: 0, section: indexToday!), at: .none, animated: true)
        }
    }
    
    @IBAction func onBtnForever(_ sender: UIButton) {
        let indexForever = arrData.firstIndex { (obj) -> Bool in
            return obj.sectionName == ForeverStr
        }
        if indexForever != nil {
            tableview.scrollToRow(at: IndexPath(row: 0, section: indexForever!), at: .none, animated: true)
        }
    }
    
    @IBAction func onBtnEdit(_ sender: Any) {
        let navVc = EditProfileViewController.instantiate(fromAppStoryboard: .Main)
        navVc.superVc = self
        navVc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(navVc, animated: true, completion: nil)
    }
    
    @IBAction func onBtnSearchOrBack(_ sender: Any) {
        if isThisDetail {
            navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - UIScrollViewDelegate
extension userProfileClass: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 1) {
            self.viewMenu.alpha = 0
        }
    }
    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate: Bool)
    {
        UIView.animate(withDuration: 3) {
            self.viewMenu.alpha = 1
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension userProfileClass: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4)
        {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellUserProfileSectionTableViewCell") as! CellUserProfileSectionTableViewCell
        cell.ConfigureCellWithData(arrData[section].sectionName)
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData[section].arrPostData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserProfilePost", for: indexPath) as! cellUserProfilePost
        let currentObj = arrData[indexPath.section].arrPostData[indexPath.row]
        cell.ConfigureCellWithData(currentObj)
        cell.delegate = self
        cell.viwMenu = viewMenu
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
}

extension userProfileClass: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if textView == txvDesc {
            DLog("\(URL)")
            let navVc = WebViewController.instantiate(fromAppStoryboard: .Main)
            navVc.webUrl = "\(URL)"
            navigationController?.pushViewController(navVc, animated: true)
        }
         return false
    }
}

extension userProfileClass: cellUserProfilePostDelegate {
    func selectedPost(indexpath: IndexPath, arrPost: [Post], selectedPostUserData: UserData) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "commentVC") as! UINavigationController
        let navVc = navController.viewControllers.first as! commentViewClass
        navVc.arrPost = arrPost
        navVc.indexpath = indexpath
        navVc.selectedPostuserData = selectedPostUserData
        navVc.isOwnProfile = true
        navVc.userProfileDataObj = userProfileData
        navController.modalPresentationStyle = .overFullScreen

        self.present(navController, animated:true, completion: nil)
    }
    
    
}


//MARK: - userProfileClass
extension userProfileClass {
    
    private func get24HourPostByUserId() {
        
        _ = APIClient.Get24HourPostByUserId(userId: userId) { (responseObj) in
            
            DispatchQueue.main.async {
                let response = responseObj ?? [String : Any]()
                let responseData = ResponseDataModel(responseObj: response)
                if responseData.success {
                    let arrNotForEverList = responseData.data as? [[[String: Any]]] ?? [[[String: Any]]]()
                    self.arrData.append(GetPostData(arrNotForEverList, TwentyFourHourStr))
                }
                if self.arrData.count > 0 {
                    self.lblNoData.isHidden = true
                } else {
                    self.lblNoData.isHidden = false
                }
                self.tableview.reloadData()

            }
        }
    }
    
    private func getForeverPostByUserId() {
        
        _ = APIClient.GetForevetPostByUserId(userId: userId) { (responseObj) in
             DispatchQueue.main.async {
                let response = responseObj ?? [String : Any]()
                let responseData = ResponseDataModel(responseObj: response)
                self.arrData.removeAll()
                if responseData.success {
                    let arrForEverList = responseData.data as? [[[String: Any]]] ?? [[[String: Any]]]()
                    self.arrData.append(GetPostData(arrForEverList, ForeverStr))
                }
                self.get24HourPostByUserId()
            }
            
        }
    }
}

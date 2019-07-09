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
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnForever: UIButton!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var lblForever: UILabel!
    @IBOutlet weak var viwProgressBar: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    
    // MARK: - Properties
    var arrData = [GetPostData]()
    var refreshControl = UIRefreshControl()
    var userId = AppPrefsManager.shared.getUserData().UserId
    var isFriend = false
    fileprivate var moreDropDown: DropDown!
    var userProfileData: UserProfileModel!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(onProgress), name: PROGRESS_NOTIFICATION_KEY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(afterSavePost), name: REFRESH_NOTIFICATION_KEY, object: nil)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "ic_nav_hedder"),
                                                                    for: .default)
        
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string: RefreshStr)
        tableview.addSubview(refreshControl)
        
        lblTitle.font = UIFont.Regular(ofSize: 20)
        lblUsername.font = UIFont.Regular(ofSize: 16)
        lblUserTag.font = UIFont.Regular(ofSize: 16)
        btnCOnnect.titleLabel?.font =  UIFont.Regular(ofSize: 16)
        btnCOnnect.addCornerRadius(8)
        btnToday.addCornerRadius(8)
        btnForever.addCornerRadius(8)
        lblToday.font = UIFont.Bold(ofSize: 15)
        lblForever.font = UIFont.Bold(ofSize: 14)
        
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
        
        btnEdit.setImage(UIImage(named: "Edit")?.tintWithColor(#colorLiteral(red: 0.2374413013, green: 0.1816716492, blue: 0.3331321776, alpha: 1)), for: .normal)
        imgUserTag.isHidden = true
        
        getUserProfileData(userId: userId, complation: { (flg, userProfileModel) in
            if flg {
                self.userProfileData = userProfileModel
                self.setData()
            }
        })
        getForeverPostByUserId()
        setDropDown()
    }
    
    private func setDropDown() {
        moreDropDown = DropDown()
        
        moreDropDown.anchorView = btnMore
        moreDropDown.dataSource = ["Block"]
        moreDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Block" {
                self.updateStatus()
            }
        }
        moreDropDown.backgroundColor = .clear
        moreDropDown.bottomOffset = CGPoint(x: -moreDropDown.frame.width, y:(moreDropDown.anchorView!.plainView.bounds.height - 80))
        
        moreDropDown.width = 90
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
        
        imgUserPic.imageFromURL(link: userProfileData.image, errorImage: #imageLiteral(resourceName: "img3"), contentMode: .scaleAspectFit)
        btnToday.setTitle(userProfileData.TotalTodayPost, for: .normal)
        btnForever.setTitle(userProfileData.TotalForeverPost, for: .normal)
        lblUserTag.text = "@" + userProfileData.username
        lblDesc.text = userProfileData.description
        lblUsername.text = userProfileData.ProfileName
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
            self.refresh(sender: notificaton)
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        self.arrData.removeAll()
        getUserProfileData(userId: userId, complation: { (flg, userProfileModel) in
            if flg {
                self.userProfileData = userProfileModel
                self.setData()
            }
        })
        getForeverPostByUserId()
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
        createFriend()
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
}

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
        cell.viwMenu = viewMenu
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
}
extension userProfileClass {
    
    private func get24HourPostByUserId() {
        
        _ = APIClient.Get24HourPostByUserId(userId: userId) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let arrNotForEverList = responseData.data as? [[[String: Any]]] ?? [[[String: Any]]]()
                self.arrData.append(GetPostData(arrNotForEverList, TwentyFourHourStr))
            }
            self.tableview.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func getForeverPostByUserId() {
        
        _ = APIClient.GetForevetPostByUserId(userId: userId) { (responseObj) in
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
    
    private func createFriend() {
        
        var paramter = [String:AnyObject]()
        paramter["idUser"] = AppPrefsManager.shared.getUserData().UserId as AnyObject
        paramter["idFriend"] = userId as AnyObject
        
        
        _ = APIClient.createFriend(parameters: paramter, success: { (resposObject) in
            let response = resposObject ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.btnCOnnect.isHidden = true
                self.view.showToastAtBottom(message: responseData.message)
            }
        })
        
    }
    
    private func updateStatus() {
        
        let param = ParameterRequest()
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserData().UserId)
        param.addParameter(key: ParameterRequest.idFriend, value: userProfileData.id)
        param.addParameter(key: ParameterRequest.Isstatus, value: false)
        
        _ = APIClient.UpdateFriendStatus(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

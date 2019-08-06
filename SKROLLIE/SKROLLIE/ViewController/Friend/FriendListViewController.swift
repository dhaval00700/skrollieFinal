//
//  FriendListViewController.swift
//  SKROLLIE
//
//  Created by PC on 06/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class FriendListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tblFriendList : UITableView!
    @IBOutlet weak var clvFriendList: UICollectionView!
    @IBOutlet weak var onBtnRequestList: UIButton!
    
    // MARK: - Properties
    private var arrUnFriendList = [UserFriendList]()
    private var isDataLoading = false
    private var continueLoadingData = true
    private var skip = 0
    private var take = 10
    private var oldSkipUnfriend = 0
    
    private var arrFriendList = [UserFriendList]()
    private var isDataLoadingFriend = false
    private var continueLoadingDataFriend = true
    private var skipFriend = 0
    private var takeFriend = 10
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    //MARK: - Methods
    func setUpUI() {
        
        tblFriendList.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        tblFriendList.delegate = self
        tblFriendList.dataSource = self
        
        clvFriendList.register(UINib(nibName: "FriendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendCollectionViewCell")
        clvFriendList.delegate = self
        clvFriendList.dataSource = self
        
        resetAll()
    }
    
    private func resetAll() {
        self.arrUnFriendList.removeAll()
        self.arrFriendList.removeAll()
        isDataLoading = false
        continueLoadingData = true
        skip = 0
        take = 10
        isDataLoadingFriend = false
        continueLoadingDataFriend = true
        skipFriend = 0
        takeFriend = 10
        getAllMyFriend()
        getAllMyUnFriend()
    }
    
    // MARK: - Actions
    @objc func refresh(sender:AnyObject) {
        resetAll()
    }
    
    @IBAction func clickToBtnConnect(_ sender : UIButton) {
        createFriend(userId: arrUnFriendList[sender.tag].idUser) { (flg) in
            if flg {
                self.resetAll()
            }
        }
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBtnRequstList(_ sender: Any) {
        let vc = RequestListViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBtnSearch(_ sender: Any) {
        let navVc = SearchViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(navVc, animated: true)
    }
}

extension FriendListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUnFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        let currentObj = arrUnFriendList[indexPath.row]
        cell.configureCellWithData(currentObj: currentObj)
        if indexPath.row == arrUnFriendList.count - 1 {
            getAllMyUnFriend()
        }
        cell.btnConnect.tag = indexPath.row
        cell.btnConnect.addTarget(self, action: #selector(clickToBtnConnect(_:)), for: .touchUpInside)
        cell.moreDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Report" {
                self.reportUser(userId: currentObj.idUser)
            } else if item == "Cancle Request" {
                self.CancleFriendRequest(userId: currentObj.idUser, completion: { (flg) in
                    if flg {
                        self.resetAll()
                    }
                })
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentObj = arrUnFriendList[indexPath.row]
        let navVc = userProfileClass.instantiate(fromAppStoryboard: .Main)
        navVc.userId = currentObj.idUser
        navVc.isFriend = false
        navVc.isThisDetail = true
        navigationController?.pushViewController(navVc, animated: true)
    }
}


extension FriendListViewController
{
    private func getAllMyUnFriend() {
        if(isDataLoading || !continueLoadingData)
        {
            return
        }
        
        isDataLoading = true
        
        _ = APIClient.GetAllMyUnFriend(limit: take, page: skip, success: { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                
                let objectData = response["data"] as? [[String: Any]] ?? [[String: Any]]()
                let tempAray = UserFriendList.getArray(data: objectData)
                
                self.arrUnFriendList.append(contentsOf: tempAray)
                
                self.skip += 1
                
                if tempAray.count < 10
                {
                    self.continueLoadingData = false
                }
                self.tblFriendList.reloadData()
            }
            self.isDataLoading = false
        })
        
    }
    
    private func getAllMyFriend() {
        if(isDataLoadingFriend || !continueLoadingDataFriend)
        {
            return
        }
        
        isDataLoadingFriend = true
        
        _ = APIClient.GetAllMyFriend(limit: takeFriend, page: skipFriend, success: { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                
                let objectData = response["data"] as? [[String: Any]] ?? [[String: Any]]()
                let tempAray = UserFriendList.getArray(data: objectData)
                
                self.arrFriendList.append(contentsOf: tempAray)
                
                self.skipFriend += 1
                
                if tempAray.count < 10
                {
                    self.continueLoadingDataFriend = false
                }
                self.clvFriendList.reloadData()
            }
            self.isDataLoadingFriend = false
        })
        
    }
}

extension FriendListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFriendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionViewCell", for: indexPath) as! FriendCollectionViewCell
        let currentObj = arrFriendList[indexPath.row]
        if indexPath.row == arrFriendList.count - 1 {
            getAllMyFriend()
        }
        if currentObj.IsAccountVerify == AccountVerifyStatus.two {
            cell.imgTag.isHidden = false
        }
        cell.imgUserPhoto.imageFromURL(link: currentObj.image, errorImage: profilePlaceHolder, contentMode: .scaleAspectFill)
        cell.lblUserName.text = currentObj.username
        cell.btnForeverCount.setTitle(currentObj.ForeverPost, for: .normal)
        cell.btnTodayPostCount.setTitle(currentObj.TodayPost, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - (5 * 3)) / 2.0
        return CGSize(width: itemWidth, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentObj = arrFriendList[indexPath.row]
        let navVc = userProfileClass.instantiate(fromAppStoryboard: .Main)
        navVc.userId = currentObj.idUser
        navVc.isFriend = true
        navVc.isThisDetail = true
        navigationController?.pushViewController(navVc, animated: true)
    }
}

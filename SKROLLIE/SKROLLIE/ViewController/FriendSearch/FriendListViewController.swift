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
    
    // MARK: - Properties
    private var arrUserFriendList = [UserFriendList]()
    private var isDataLoading = false
    private var continueLoadingData = true
    private var skip = 0
    private var take = 10
    private var refreshControl = UIRefreshControl()
    
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
        print("*")
        print("**")
        print("***")
        print("****")
        print("*****")
        print("******")
        
        
        tblFriendList.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        tblFriendList.delegate = self
        tblFriendList.dataSource = self
        
        clvFriendList.register(UINib(nibName: "FriendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendCollectionViewCell")
        clvFriendList.delegate = self
        clvFriendList.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string: RefreshStr)
        tblFriendList.addSubview(refreshControl)
        
        getFriendList()
        
    }
    
    private func resetAll() {
        self.arrUserFriendList.removeAll()
        isDataLoading = false
        continueLoadingData = true
        skip = 0
        take = 10
        getFriendList()
    }
    
    // MARK: - Actions
    @objc func refresh(sender:AnyObject) {
        resetAll()
    }
    
    @IBAction func clickToBtnConnect(_ sender : UIButton) {
        createFriend(currebtObj: arrUserFriendList[sender.tag])
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension FriendListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        let currentObj = arrUserFriendList[indexPath.row]
        if indexPath.row == arrUserFriendList.count - 1 {
            getFriendList()
        }
        if currentObj.IsAccountVerify == AccountVerifyStatus.two {
            cell.imgShield.isHidden = false
        }
        cell.imgProfile.imageFromURL(link: currentObj.image, errorImage: #imageLiteral(resourceName: "img3"), contentMode: .scaleAspectFit)
        cell.lblUserName.text = currentObj.username
        cell.lblUserDescription.text = currentObj.FullName
        cell.btnConnect.isHidden = currentObj.IsMyFriend
        cell.btnConnect.tag = indexPath.row
        cell.btnConnect.addTarget(self, action: #selector(clickToBtnConnect(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentObj = arrUserFriendList[indexPath.row]
        let navVc = userProfileClass.instantiate(fromAppStoryboard: .Main)
        navVc.userId = currentObj.idUser
        navVc.isFriend = currentObj.IsMyFriend
        navigationController?.pushViewController(navVc, animated: true)
    }
}


extension FriendListViewController
{
    private func getFriendList() {
        if(isDataLoading || !continueLoadingData)
        {
            return
        }
        
        isDataLoading = true
        
        _ = APIClient.GetFriendList(limit: take, page: skip, success: { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                
                let objectData = response["data"] as? [[String: Any]] ?? [[String: Any]]()
                let tempAray = UserFriendList.getArray(data: objectData)
                
                self.arrUserFriendList.append(contentsOf: tempAray)
                
                self.skip += 1
                
                if tempAray.count < 10
                {
                    self.continueLoadingData = false
                }
                self.tblFriendList.reloadData()
            }
            self.refreshControl.endRefreshing()
            self.isDataLoading = false
        })
        
    }
    
    private func createFriend(currebtObj:UserFriendList) {
        
        var paramter = [String:AnyObject]()
        paramter["idUser"] = AppPrefsManager.shared.getUserData().UserId as AnyObject
        paramter["idFriend"] = currebtObj.idUser as AnyObject
        
        _ = APIClient.createFriend(parameters: paramter, success: { (resposObject) in
            let response = resposObject ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.view.showToastAtBottom(message: responseData.message)
                currebtObj.IsMyFriend = true
                self.tblFriendList.reloadData()
            }
        })
        
    }
}

extension FriendListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionViewCell", for: indexPath) as! FriendCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width - (5 * 2)
        return CGSize(width: itemWidth, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

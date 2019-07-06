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
    
    // MARK: - Properties
    var arrUserFriendList = [UserFriendList]()
    var isDataLoading = false
    var continueLoadingData = true
    var skip = 0
    var take = 10
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    //MARK: - Methods
    func setUpUI() {
        tblFriendList.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        tblFriendList.delegate = self
        tblFriendList.dataSource = self
        getFriendList()
        
    }
    
    // MARK: - Actions
    @IBAction func clickToBtnConnect(_ sender : UIButton) {
        createFriend(currebtObj: arrUserFriendList[sender.tag])
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
                
                let objectData = response["data"] as? [AnyObject] ?? [AnyObject]()
                let tempAray = UserFriendList.getArray(data: objectData)
                
                self.arrUserFriendList.append(contentsOf: tempAray)
                
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
    
    private func createFriend(currebtObj:UserFriendList) {
        
        var paramter = [String:AnyObject]()
        paramter["idUser"] = AppPrefsManager.shared.getUserData().UserId as AnyObject
        paramter["idFriend"] = currebtObj.idUser as AnyObject
        
        
        _ = APIClient.createFriend(parameters: paramter, success: { (resposObject) in
            let response = resposObject ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.view.showToastAtBottom(message: responseData.message)
                self.getFriendList()
            }
        })
        
    }
}

//
//  BlockListViewController.swift
//  SKROLLIE
//
//  Created by PC on 06/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class BlockListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tblBlockList : UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    // MARK: - Properties
    var arrBlockList = [BlockListData]()
    private var refreshControl = UIRefreshControl()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    // MARK: - Methods
    func setUpUI() {
        tblBlockList.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        tblBlockList.delegate = self
        tblBlockList.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string: RefreshStr)
        tblBlockList.addSubview(refreshControl)
        
        lblNoData.isHidden = false
        getBlockList()
        
    }
    
    // MARK: - Actions
    
    
    @objc func refresh(sender:AnyObject) {
        getBlockList()
    }
    
    @IBAction func clickToBtnConnect(_ sender : UIButton) {
        updateStatus(userId: arrBlockList[sender.tag].idFriend, isBlock: false) { (flg) in
            if flg {
                self.getBlockList()
            }
        }
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension BlockListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBlockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        let currentObj = arrBlockList[indexPath.row]
        if currentObj.tbluserinformation.IsAccountVerify == AccountVerifyStatus.two {
            cell.imgShield.isHidden = false
        }
        cell.imgProfile.imageFromURL(link: currentObj.tbluserinformation.image, errorImage: profilePlaceHolder, contentMode: .scaleAspectFill)
        cell.lblUserName.text = currentObj.tbluserinformation.username
        cell.lblUserDescription.text = currentObj.tbluserinformation.FullName
        cell.btnConnect.tag = indexPath.row
        cell.btnConnect.setTitle("Unblock", for: .normal)
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


extension BlockListViewController {
    private func getBlockList() {
        _ = APIClient.GetAllBlockFriendByUser(userId: AppPrefsManager.shared.getUserData().UserId) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            self.arrBlockList.removeAll()
            if responseData.success {
                let aryGetPhotos = responseData.data as? [[String: Any]] ?? [[String: Any]]()
                self.arrBlockList = BlockListData.getArray(data: aryGetPhotos)
            }
            if self.arrBlockList.count > 0 {
                self.lblNoData.isHidden = true
            } else {
                self.lblNoData.isHidden = false
            }
            
            self.tblBlockList.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

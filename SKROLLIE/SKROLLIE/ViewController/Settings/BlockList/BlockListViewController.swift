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
        
        getBlockList()
        
    }
    
    // MARK: - Actions
    
    
    @objc func refresh(sender:AnyObject) {
        getBlockList()
    }
    
    @IBAction func clickToBtnConnect(_ sender : UIButton) {
        updateStatus(arrBlockList[sender.tag])
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
        cell.imgProfile.imageFromURL(link: currentObj.tbluserinformation.image, errorImage: #imageLiteral(resourceName: "img3"), contentMode: .scaleAspectFit)
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
            if responseData.success {
                self.arrBlockList.removeAll()
                let aryGetPhotos = responseData.data as? [[String: Any]] ?? [[String: Any]]()
                self.arrBlockList = BlockListData.getArray(data: aryGetPhotos)
                self.tblBlockList.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    private func updateStatus(_ obj: BlockListData) {
        
        let param = ParameterRequest()
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserData().UserId)
        param.addParameter(key: ParameterRequest.idFriend, value: obj.idFriend)
        param.addParameter(key: ParameterRequest.IsBlock, value: false)
        
        _ = APIClient.BlockUnblockFriendByUser(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.getBlockList()
            }
        }
    }
}

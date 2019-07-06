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
        getBlockList()
        
    }
    
    // MARK: - Actions
    @IBAction func clickToBtnConnect(_ sender : UIButton) {
        //createFriend(currebtObj: arrUserFriendList[sender.tag])
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


extension BlockListViewController {
    private func getBlockList() {
        _ = APIClient.GetAllBlockFriendByUser(userId: AppPrefsManager.shared.getUserData().UserId) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let aryGetPhotos = responseData.data as? [[String: Any]] ?? [[String: Any]]()
                self.arrBlockList = BlockListData.getArray(data: aryGetPhotos)
                self.tblBlockList.reloadData()
            }
        }
    }
}

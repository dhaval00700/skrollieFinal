//
//  RequestListViewController.swift
//  SKROLLIE
//
//  Created by PC on 22/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class RequestListViewController: BaseViewController {

    @IBOutlet weak var tblRequestList: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    private var arrUnFriendList = [UserFriendList]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        tblRequestList.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        tblRequestList.delegate = self
        tblRequestList.dataSource = self
        lblNoData.isHidden = false
        getFriendByUser()
    }
    
    // MARK: - Actions
   
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBtnAccept(_ sender: UIButton) {
        let currentObj = arrUnFriendList[sender.tag]
        acceptFriendRequest(id: currentObj.idUser)
    }
    
}

//MARK: - RequestListViewController
extension RequestListViewController {
    
    private func getFriendByUser() {
        
        _ = APIClient.GetFriendReuestedByUser(parameters: [String : Any](), success: { (resposObject) in
            let response = resposObject ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.arrUnFriendList = UserFriendList.getArray(data: response["data"] as? [[String : Any]] ?? [[String : Any]]())
                if self.arrUnFriendList.count > 0 {
                    self.lblNoData.isHidden = true
                } else {
                    self.lblNoData.isHidden = false
                }
                self.tblRequestList.reloadData()
            }
        })
    }
    
    private func acceptFriendRequest(id:String) {
        let param = ParameterRequest()
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserData().UserId)
        param.addParameter(key: ParameterRequest.idFriend, value: id)
        
        _ = APIClient.AcceptFriendRequest(parameters: param.parameters, success: { (resposObject) in
            let response = resposObject ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
               self.navigationController?.popViewController(animated: true)
            }
        })
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension RequestListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUnFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        
        let currentObj = arrUnFriendList[indexPath.row]
        
        if currentObj.IsAccountVerify == AccountVerifyStatus.two {
            cell.imgShield.isHidden = false
        }
        cell.imgProfile.imageFromURL(link: currentObj.image, errorImage: #imageLiteral(resourceName: "img3"), contentMode: .scaleAspectFit)
        cell.lblUserName.text = currentObj.username
        cell.lblUserDescription.text = currentObj.FullName
        cell.btnConnect.setTitle("Accept", for: .normal)
        cell.btnConnect.tag = indexPath.row
        cell.btnConnect.addTarget(self, action: #selector(onBtnAccept(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
       
}

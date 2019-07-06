//
//  BlockListViewController.swift
//  SKROLLIE
//
//  Created by PC on 06/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class BlockListViewController: BaseViewController {
    
    @IBOutlet weak var tblBlockList : UITableView!
    
    var arrUserFriendList = [UserFriendList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    //MARK: - Methods
    
    func setUpUI() {
        tblBlockList.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        tblBlockList.delegate = self
        tblBlockList.dataSource = self
        //getFriendList()
        
    }
    
    //MARK: - CLick events
    
    @IBAction func clickToBtnConnect(_ sender : UIButton) {
        //createFriend(currebtObj: arrUserFriendList[sender.tag])
    }
    
    
}

extension BlockListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        let currentObj = arrUserFriendList[indexPath.row]
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

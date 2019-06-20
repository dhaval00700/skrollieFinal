//
//  userProfileClass.swift
//  SKROLLIE
//
//  Created by brainstorm on 09/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class userProfileClass: UIViewController
{
    //Mark:= Outlet
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var imgUserPic: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUserTag: UILabel!
    @IBOutlet weak var imgUserTag: UIImageView!
    @IBOutlet weak var btnCOnnect: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnTodayCnt: UIButton!
    @IBOutlet weak var btnForeverCnt: UIButton!
    @IBOutlet weak var lblFrnd: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnForever: UIButton!
    @IBOutlet weak var btnToday: UIButton!
    
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var lblForever: UILabel!
    
    
    var resultForeverPost = GetFourEverHourData()
    var result24HrPost = Get24HourData()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "ic_nav_hedder"),
                                                                    for: .default)
        lblTitle.font = UIFont.Regular(ofSize: 20)
        lblUsername.font = UIFont.Regular(ofSize: 16)
        lblUserTag.font = UIFont.Regular(ofSize: 16)
        lblFrnd.font = UIFont.Regular(ofSize: 16)
        btnCOnnect.titleLabel?.font =  UIFont.Regular(ofSize: 16)
        btnCOnnect.addCornerRadius(8)
        btnToday.addCornerRadius(8)
        btnForever.addCornerRadius(8)
        lblDesc.font = UIFont.Regular(ofSize: 9)
        lblToday.font = UIFont.Regular(ofSize: 9)
        
        imgUserTag.image = #imageLiteral(resourceName: "ic_shield").tintWithColor(.purple)
        
        tableview.register(UINib(nibName: "cellUserProfilePost", bundle: nil), forCellReuseIdentifier: "cellUserProfilePost")
        tableview.register(UINib(nibName: "CellUserProfileSectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CellUserProfileSectionTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        
        btnCOnnect.isHidden = true
        
        getForeverPostByUserId()
    }
    
    @IBAction func btnSetting(_ sender: UIButton)
    {
        performSegue(withIdentifier: "unwineToLogout", sender: self)
    }
    @IBAction func btnUserProfile(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnUserPicture(_ sender: UIButton)
    {
        
    }
    @IBAction func btnFrndReaction(_ sender: UIButton)
    {
        
    }
    @IBAction func btnFrndList(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnConnect(_ sender: Any) {
    }
    @IBAction func btnMore(_ sender: Any) {
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
        return 2
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
        if section == 0 {
            cell.lblTitle.text = "Forever"
        } else {
            cell.lblTitle.text = "24 Hour"
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return resultForeverPost.arrFourEverHourData.count
        } else {
            return result24HrPost.arr24HourData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserProfilePost", for: indexPath) as! cellUserProfilePost
        if indexPath.section == 0 {
            cell.collectionData = resultForeverPost.arrFourEverHourData[indexPath.row]
        } else {
            cell.collectionData = result24HrPost.arr24HourData[indexPath.row]
        }
        cell.clvPost.reloadData()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
}
extension userProfileClass {
    
    @objc func get24HourPostByUserId() {
        
        _ = APIClient.Get24HourPostByUserId() { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let arrNotForEverList = responseData.data as? [[[String: Any]]] ?? [[[String: Any]]]()
                self.result24HrPost = Get24HourData(data: arrNotForEverList)
                self.tableview.reloadData()
            }
        }
    }
    
    @objc func getForeverPostByUserId() {
        
        _ = APIClient.GetForevetPostByUserId() { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let arrForEverList = responseData.data as? [[[String: Any]]] ?? [[[String: Any]]]()
                self.resultForeverPost = GetFourEverHourData(data: arrForEverList)
            }
            self.get24HourPostByUserId()
        }
    }
}

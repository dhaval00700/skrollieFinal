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
    
    
    var resultForeverPost = [Post]()
    var result24HrPost = [Post]()
    
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
        lblDesc.font = UIFont.Regular(ofSize: 9)
        lblToday.font = UIFont.Regular(ofSize: 9)
        
        tableview.register(UINib(nibName: "cellUserProfilePost", bundle: nil), forCellReuseIdentifier: "cellUserProfilePost")
        tableview.delegate = self
        tableview.dataSource = self
        
        let idpass = (SingleToneClass.sharedInstance.loginDataStore["UserId"] as AnyObject)
        
        var userId = String()
        if let userIDString = idpass as? String
        {
            userId = "\(userIDString)"
        }
        
        if let userIDInt = idpass as? Int
        {
            userId = "\(userIDInt)"
        }
        
        webserviceofGetPhoto(UserId: userId)
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
        viewMenu.isHidden = true
    }
    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate: Bool)
    {
        viewMenu.isHidden = false
    }
}

extension userProfileClass: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4)
        {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserProfilePost", for: indexPath) as! cellUserProfilePost
        if indexPath.row == 0 {
            cell.lblTitle.text = "Forever"
            cell.collectionData = resultForeverPost
        } else {
            cell.lblTitle.text = "24 Hour"
            cell.collectionData = result24HrPost
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
    func webserviceofGetPhoto(UserId :String)
    {
        webserviceForGetAllPostByIdUser(id: UserId){(result, status) in
            
            if status
            {
                do
                {
                    let arrForEverList = (((result as! [String : AnyObject])["ForEverList"] as! [[String:AnyObject]]))
                    let arrNotForEverList = (((result as! [String : AnyObject])["NotForEverList"] as! [[String:AnyObject]]))
                    
                    self.resultForeverPost = Post.getArrayPost(data: arrForEverList, userName: "")
                    self.result24HrPost = Post.getArrayPost(data: arrNotForEverList, userName: "")
                    self.tableview.reloadData()
                }
                    
                catch let DecodingError.dataCorrupted(context)
                {
                    print(context)
                }
                catch let DecodingError.keyNotFound(key, context)
                {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch let DecodingError.valueNotFound(value, context)
                {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch let DecodingError.typeMismatch(type, context)
                {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch
                {
                    print("error: ", error)
                }
            }
                
            else
            {
                print((result as! [String:AnyObject])["message"] as! String)
            }
        }
    }
}

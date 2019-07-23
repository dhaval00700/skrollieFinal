//
//  HomeViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/23/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController
{
    
    // MARK: - Outlets
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMenuProfile: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    
    // MARK: - Properties
    var resultImgPhoto = [UserData]()
    var refreshControl = UIRefreshControl()
    
    // MARK: - LifeCycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgMenuProfile.imageFromURL(link: AppPrefsManager.shared.getUserProfileData().image, errorImage: #imageLiteral(resourceName: "img12"), contentMode: .scaleToFill)
    }
    
    // MARK: - Methods
    func setupUI() {
        tblData.register(UINib(nibName: "HomeTblCell", bundle: nil), forCellReuseIdentifier: "HomeTblCell")
        tblData.delegate = self
        tblData.dataSource = self
        lblTitle.font = UIFont.Regular(ofSize: 20)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "ic_nav_hedder"),
                                                                    for: .default)
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string: RefreshStr)
        tblData.addSubview(refreshControl)
        
        lblNoData.isHidden = false
        getAllPost()
    }
    
    // MARK: - Actions
    @objc func refresh(sender:AnyObject) {
        getAllPost()
    }
    
    @IBAction func btnSetting(_ sender: UIButton) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "SettingVc") as! UINavigationController
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated:true, completion: nil)
    }
    
    @IBAction func btnCamera(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CameraAndVedioViewController") as? CameraAndVedioViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnUserProfile(_ sender: UIButton) {
        let obj: userProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "userProfileClass") as! userProfileClass
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnUserPicture(_ sender: UIButton) {
        
    }
    
    @IBAction func btnFrndList(_ sender: UIButton) {
        let navVc = FriendListViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(navVc, animated: true)
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultImgPhoto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTblCell", for: indexPath) as! HomeTblCell
        cell.ConfigureCellWithData(resultImgPhoto[indexPath.row])
        cell.viwMenu = viewMenu
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
}


extension HomeViewController: UIScrollViewDelegate {
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

extension HomeViewController
{
    private func getAllPost() {
        _ = APIClient.GetAllPost { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let aryGetPhotos = responseData.data as? [[String: Any]] ?? [[String: Any]]()
                self.resultImgPhoto = UserData.getArrayPost(datas: aryGetPhotos)
            }
            if self.resultImgPhoto.count > 0 {
                self.lblNoData.isHidden = true
            } else {
                self.lblNoData.isHidden = false
            }
            self.tblData.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}


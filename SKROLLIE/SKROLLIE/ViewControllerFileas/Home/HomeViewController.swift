//
//  HomeViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/23/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController
{
    
    //Mark: Outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var viewMenu: UIView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viwProgressBar: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblFrnds: UILabel!
    
    //MARK: Properties
    var labelEmptyMessage = UILabel()
    var imagePicker = UIImagePickerController()
    var dictdata = [String:AnyObject]()
    
    var resultImgPhoto = [UserData]()
    var arydatsta = [[String:AnyObject]]()
    var collectionData = UserData()
    var arysectionData = ["@jhongoe","@mayjane","@tonnystark","@natgeo","@natgeo","@natgeo"]
    
    //MARK: Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viwProgressBar.isHidden = true
        lblUsername.font = UIFont.Regular(ofSize: 16)
        lblFrnds.font = UIFont.Regular(ofSize: 16)
        lblTitle.font = UIFont.Regular(ofSize: 20)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "ic_nav_hedder"),
                                                                    for: .default)
        webserviceofGetPhoto()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(onProgress), name: Notification.Name("PROGRESS"), object: nil)
    }
    
    @objc func onProgress(_ notificaton: NSNotification) {
        viwProgressBar.isHidden = false
        guard let userInfo = notificaton.userInfo,
            let obj = userInfo as? [String: Any] else { return }
        let uploadProgress = obj["uploadProgress"] as! Float
        progressBar.progress = uploadProgress
        if uploadProgress == 1.0 {
            viwProgressBar.isHidden = true
        }
    }
    
    //MARK: Actions
    @IBAction func btnSetting(_ sender: UIButton)
    {
        performSegue(withIdentifier: "UnwineSegueForLogout", sender: self)
    }
    @IBAction func btnCamera(_ sender: UIButton)
    {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CameraAndVedioViewController") as? CameraAndVedioViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnUserProfile(_ sender: UIButton)
    {
        let obj: userProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "userProfileClass") as! userProfileClass
        self.navigationController?.pushViewController(obj, animated: true)
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
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return collectionData.arrPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let datas = collectionData.arrPost[indexPath.item]
        cell.imgUserPic.sd_setImage(with: URL(string: datas.Url), completed: nil)
        
        cell.lblUserName.text = collectionData.ProfileName
        cell.lblUserName.font = UIFont.Regular(ofSize: 16)
        cell.lblTimeOfPhotos.font = UIFont.Regular(ofSize: 12)

        if indexPath.row == 0
        {
            cell.viewOfUserProfileBackground.isHidden = false
            cell.lblUserName.isHidden = false
        }
        else
        {
            cell.viewOfUserProfileBackground.isHidden = true
            cell.lblUserName.isHidden = true
        }
        if  indexPath.item % 2 == 0
        {
            cell.lblTimeOfPhotos.text = "24 H O U R S  L E F T"
        }
        else
        {
            cell.lblTimeOfPhotos.text = "F O R E V E R"
        }
        
        
        if cell.lblTimeOfPhotos.text == "24 H O U R S  L E F T"
        {
            cell.viewAllocColourDependOnTime.backgroundColor = UIColor.init(red: 154/255, green: 191/255, blue: 34/255, alpha: 1.0)//9ABF22
        }
        else
        {
            cell.viewAllocColourDependOnTime.backgroundColor = UIColor.init(red: 245/255, green: 232/255, blue: 39/255, alpha: 1.0)//F5E827
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj: commentViewClass = self.storyboard?.instantiateViewController(withIdentifier: "commentViewClass") as! commentViewClass
        obj.isOwnProfile = false
        self.present(obj, animated: true, completion: nil)
        
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
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        collectionData = resultImgPhoto[indexPath.row]
        cell1.collectionView.delegate = self
        cell1.collectionView.dataSource = self
        cell1.collectionView.reloadData()
        return cell1
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 0
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
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
    
    func webserviceofGetPhoto()
    {
        var dictdata = [String:AnyObject]()
        
        let idpass = (SingleToneClass.sharedInstance.loginDataStore["data"] as AnyObject)
        
        let userId = idpass["id"] as? String ?? "\(String(describing: idpass["id"] as? Int))"
        
        dictdata[keyAllKey.KidUser] = userId as AnyObject
        
        webserviceForGetPhoto(dictdata: dictdata as AnyObject){(result, status) in
            
            if status
            {
                do
                {
                 let aryGetPhotos = (((result as! [String : AnyObject])["data"] as! [[String:AnyObject]]))

                    self.resultImgPhoto = UserData.getArrayPost(datas: aryGetPhotos)
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
    
    
    func webserviceOfDeletePost()
    {
        var dictdata = [String:AnyObject]()
        
        let idpass = (SingleToneClass.sharedInstance.loginDataStore["data"] as AnyObject)
        var userId = String()
        
        if let userIDString = idpass["id"] as? String
        {
            userId = "\(userIDString)"
        }
        
        if let userIDInt = idpass["id"] as? Int
        {
            userId = "\(userIDInt)"
        }
        dictdata[keyAllKey.id] = userId as AnyObject
        
        webserviceForDeletePhoto(dictParams: dictdata as AnyObject){(result, status) in
            
            if status
            {
                do
                {
                    print((result as! [String:AnyObject])["message"] as! String)
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
    
    func webserviceOfSavePhoto()
    {
        var dictdata = [String:AnyObject]()
        
        let idpass = (SingleToneClass.sharedInstance.loginDataStore["data"] as AnyObject)
        var userId = String()
        if let userIDString = idpass["id"] as? String
        {
            userId = "\(userIDString)"
        }
        
        if let userIDInt = idpass["id"] as? Int
        {
            userId = "\(userIDInt)"
        }
        dictdata[keyAllKey.KidUser] = userId as AnyObject
        dictdata[keyAllKey.id] = "1" as AnyObject
        dictdata[keyAllKey.Isstatus] = true as AnyObject
        dictdata[keyAllKey.idFriend] = "2" as AnyObject
        
        webserviceForCreateFrnd(dictdata as AnyObject) { (result, status) in
            
            if status
            {
                do
                {
                    print((result as! [String:AnyObject])["message"] as! String)
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


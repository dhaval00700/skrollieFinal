//
//  HomeViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/23/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit


//MARK: - All UIImage Extension
extension UIImage {
    
    func tintWithColor(_ color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale);
        //UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        
        // flip the image
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context?.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.fill(rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    
}


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
    var resultImgPhoto = [UserData]()
    var collectionData = UserData()
    
    //MARK: Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UINib(nibName: "HomeTblCell", bundle: nil), forCellReuseIdentifier: "HomeTblCell")
        
        viwProgressBar.isHidden = true
        lblFrnds.font = UIFont.Regular(ofSize: 16)
        lblTitle.font = UIFont.Regular(ofSize: 20)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "ic_nav_hedder"),
                                                                    for: .default)
        
        
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
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "HomeTblCell", for: indexPath) as! HomeTblCell
        collectionData = resultImgPhoto[indexPath.row]
        cell1.collectionData = resultImgPhoto[indexPath.row]
        cell1.Collectionview.reloadData()
        cell1.lblUserName.text = collectionData.ProfileName
        cell1.lblUserName.font = UIFont.Regular(ofSize: 16)
        
        return cell1
        
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
    
    func webserviceofGetPhoto(UserId :String)
    {
        webserviceForGetPhoto(id: UserId){(result, status) in
            
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
}


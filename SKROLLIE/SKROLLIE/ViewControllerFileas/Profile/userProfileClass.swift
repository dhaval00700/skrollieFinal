//
//  userProfileClass.swift
//  SKROLLIE
//
//  Created by brainstorm on 09/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class userProfileClass: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout
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
    
    var labelEmptyMessage = UILabel()
    var imagePicker = UIImagePickerController()
    var dictdata = [String:AnyObject]()
    
    var arysection = [String]()
    var arysection2 = [String]()
    var arysection3 = [String]()
    var arysection4 = [String]()
    
    var arydatsta = [[String:AnyObject]]()
    
    var arysectionData = ["TODAY","FOREVER",""]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "ic_nav_hedder"),
                                                                    for: .default)
        //    Data not found
        //        mainScrollView.delegate = self
        //        labelEmptyMessage.frame = self.view.bounds
        //        labelEmptyMessage.text = "There is no data available."
        //        labelEmptyMessage.textAlignment = .center
        //        self.view.addSubview(labelEmptyMessage)
        
        arysection = ["TODAY","FOREVER",""]
        lblTitle.font = UIFont.Regular(ofSize: 20)
        lblUsername.font = UIFont.Regular(ofSize: 16)
        lblUserTag.font = UIFont.Regular(ofSize: 16)
        lblFrnd.font = UIFont.Regular(ofSize: 16)
        btnCOnnect.titleLabel?.font =  UIFont.Regular(ofSize: 16)
        lblDesc.font = UIFont.Regular(ofSize: 9)
        lblToday.font = UIFont.Regular(ofSize: 9)
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - button Action Methods
    //-------------------------------------------------------------
    
    
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
    //-------------------------------------------------------------
    // MARK: - CollectionView Methods
    //-------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arysection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
     
//        let data = arysection[collectionView.tag]
        
        cell.imgUserProfilePic.image = UIImage(named: "img4")
        cell.imgUserPic.image = UIImage(named: "ic_bg_home_cell")

        if indexPath.row == 0
        {
            cell.viewOfUserProfileBackground.isHidden = false
        }
        else
        {
            cell.viewOfUserProfileBackground.isHidden = true
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
     //   cell.lblUserName.font = UIFont.Regular(ofSize: 16)
        cell.lblTimeOfPhotos.font = UIFont.Regular(ofSize: 12)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize.init(width: 221, height: 130)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj: commentViewClass = self.storyboard?.instantiateViewController(withIdentifier: "commentViewClass") as! commentViewClass
        obj.isOwnProfile = true
        self.present(obj, animated: true, completion: nil)
    }
    //-------------------------------------------------------------
    // MARK: - Tableview Methods
    //-------------------------------------------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arysection.count
    }
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
        let section = self.arysectionData[section]
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell1.collectionView.delegate = self
        cell1.collectionView.dataSource = self
        
        cell1.collectionView.tag = indexPath.section
        let username = arysection[indexPath.section]
        cell1.lblUserName.text = username
        return cell1
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let section = self.arysectionData[indexPath.section]
        let headline = arysectionData[indexPath.row]
        
        cell.textLabel?.text = headline
        cell.detailTextLabel?.text = headline
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 2
        {
            return 136
        }
        return 163
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if (segue.identifier == "") {
        //
        //            let HomeVC = segue.destination as!
        //
        //        }
        //    }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewMenu.isHidden = true
    }
    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate: Bool)
    {
        viewMenu.isHidden = false
    }
    
    //---------------------------------------------------------------
    //MARK: - ActionSheet
    //---------------------------------------------------------------
    
    func showAlertForImagePicker()
    {
        let alert = UIAlertController(title: "", message: "Please Select Image", preferredStyle: .actionSheet)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .foregroundColor : UIColor.black
            ], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .foregroundColor : UIColor.black
            ], for: .highlighted)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.imagePicker.sourceType = .camera
            
            self.imagePicker.navigationBar.isTranslucent = false
            self.imagePicker.navigationBar.barTintColor = UIColor.white
            self.imagePicker.navigationBar.tintColor = UIColor.white
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            
            self.imagePicker.navigationBar.isTranslucent = false
            self.imagePicker.navigationBar.barTintColor = UIColor.white
            self.imagePicker.navigationBar.tintColor = UIColor.white
            
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
    }
    
}

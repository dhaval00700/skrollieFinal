//
//  HomeViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/23/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate
{

    //Mark:= Outlet
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var viewMenu: UIView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblFrnds: UILabel!
    var labelEmptyMessage = UILabel()
    var imagePicker = UIImagePickerController()
    var dictdata = [String:AnyObject]()
    
    var arysection = [String]()
    var arysection2 = [String]()
    var arysection3 = [String]()
    var arysection4 = [String]()
   
    var arydatsta = [[String:AnyObject]]()
    
    var arysectionData = ["@jhongoe","@mayjane","@tonnystark","@natgeo","@natgeo","@natgeo"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       lblUsername.font = UIFont.Regular(ofSize: 16)
       lblFrnds.font = UIFont.Regular(ofSize: 16)
       lblTitle.font = UIFont.Regular(ofSize: 20)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "ic_nav_hedder"),
                                                                    for: .default)
//    Data not found
//        mainScrollView.delegate = self
//        labelEmptyMessage.frame = self.view.bounds
//        labelEmptyMessage.text = "There is no data available."
//        labelEmptyMessage.textAlignment = .center
//        self.view.addSubview(labelEmptyMessage)
        
        arysection = ["img1","img2","img3","img4","img4","img4"]
        
        //Dummy data display
        
        //        arysection2 = ["img3","img4"]
        //        arysection3 = ["img5","img6"]
        //        arysection4 = ["img1","img2"]
        //        arysection5 = ["img3","img4"]
        //         = ["img5","img6"]
        
//        dictdata["name"] = "Mary" as AnyObject
//        dictdata["img"] = "img1"  as AnyObject
//        dictdata["img1"] = "img3"  as AnyObject
//        arydatsta.append(dictdata)
//        arydatsta.removeAll()
//
//        dictdata["name"] = "Jhon"  as AnyObject
//        dictdata["img"] = "img2"  as AnyObject
//        dictdata["img1"] = "img4"  as AnyObject
//        arydatsta.append(dictdata)
//        arydatsta.removeAll()
//
//        dictdata["name"] = "Mike" as AnyObject
//        dictdata["img"] = "img3"  as AnyObject
//        dictdata["img1"] = "img5"  as AnyObject
//        arydatsta.append(dictdata)
//        arydatsta.removeAll()
//
//        dictdata["name"] = "Michale"  as AnyObject
//        dictdata["img"] = "img4"  as AnyObject
//        dictdata["img1"] = "img6"  as AnyObject
//        arydatsta.append(dictdata)
//        arydatsta.removeAll()
//
//        dictdata["name"] = "Cristefar"  as AnyObject
//        dictdata["img"] = "img5"  as AnyObject
//        dictdata["img1"] = "img1"  as AnyObject
//        arydatsta.append(dictdata)
//        arydatsta.removeAll()
//
//        dictdata["name"] = "liza"  as AnyObject
//        dictdata["img"] = "img6"  as AnyObject
//        dictdata["img1"] = "img2"  as AnyObject
//        arydatsta.append(dictdata)

    }

    //-------------------------------------------------------------
    // MARK: - button Action Methods
    //-------------------------------------------------------------
    
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

        var strName = String()
        let data = arysection[indexPath.item]
   
            cell.imgUserProfilePic.image = UIImage(named: "img4" )
            cell.imgUserPic.image = UIImage(named: "ic_bg_home_cell" )

//        if indexPath.item == 0
//        {
            let username = arysectionData[indexPath.item]
            cell.lblUserName.text = username
            cell.lblUserName.font = UIFont.Regular(ofSize: 16)
              cell.lblTimeOfPhotos.font = UIFont.Regular(ofSize: 12)
//        }
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
        else //cell.lblTimeOfPhotos.text == "F O R E V E R"
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
    //-------------------------------------------------------------
    // MARK: - Tableview Methods
    //-------------------------------------------------------------

    
     func numberOfSections(in tableView: UITableView) -> Int {
        return arysection.count // self.arysectionData.count
    }

//
//     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//
//        let section = self.arysectionData[section]
//
//        return section
//    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.arysectionData[section]
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
                cell1.collectionView.delegate = self
                cell1.collectionView.dataSource = self
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
        return 180
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

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 0
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

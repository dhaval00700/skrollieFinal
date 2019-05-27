//
//  commentViewClass.swift
//  SKROLLIE
//
//  Created by brainstorm on 10/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class commentViewClass: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,FSPagerViewDelegate,FSPagerViewDataSource,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var txtWriteReview: UITextField!
    
    @IBOutlet weak var lbltwoMojiCoonects: UILabel!
    @IBOutlet weak var lblTotalCmt: UILabel!
    @IBOutlet weak var lblViewAllviewers: UILabel!
    
    //    @IBOutlet weak var collectionViewUserImgList: UICollectionView!
    @IBOutlet weak var viewUserProfile: UIView!
    @IBOutlet weak var viewEmoji: UIView!
    @IBOutlet weak var viewAllComment: UIView!
    @IBOutlet weak var viewSavePhotos: UIView!
    
    @IBOutlet weak var btnViewAllComment: UIButton!


    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var imgPost: UIImageView!

    @IBOutlet weak var collectionUserList: UICollectionView!
   @IBOutlet weak var tblView: UITableView!
    
   @IBOutlet weak var emojiPagerView: FSPagerView!
    @IBOutlet weak var btnViewCount: UIButton!
    
    var aryUserList = [String]()
    var aryImg = [String]()
    var isOwnProfile: Bool = false
    var CountOfUserProfile = Int()
    
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.linear,.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]

    
    //MARK: - ViewMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        collectionUserList.delegate = self
        collectionUserList.dataSource = self
        
        aryUserList = ["@happyCampper","@doggylover","@horedude"]
        aryImg = ["img5","img6","img5"]
         collectionUserList.reloadData()
        tblView.reloadData()
        
        emojiPagerView.delegate = self
        emojiPagerView.dataSource = self
        self.emojiPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
        self.emojiPagerView.itemSize = CGSize.init(width: 60, height: 40)//self.emojiPagerView.frame.size.applying(transform)
        self.emojiPagerView.decelerationDistance = FSPagerView.automaticDistance
        let type = self.transformerTypes[0]
        self.emojiPagerView.transformer = FSPagerViewTransformer(type:type)
        
        lbltwoMojiCoonects.font = UIFont.Bold(ofSize: 15)
        lblViewAllviewers.font = UIFont.Bold(ofSize: 15)
        btnViewCount.titleLabel?.font = UIFont.Bold(ofSize: 15)
        
      
        if isOwnProfile == true
        {
            viewAllComment.isHidden = false
        }
        else
        {
            viewAllComment.isHidden = true
        }
    }
    
    // MARK: - Action
    @IBAction func btnDismiss(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - CollectionView Methods
    //-------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return aryUserList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCommentListCollectionViewCell", for: indexPath) as! UserCommentListCollectionViewCell

        let imgOfUser = aryImg[indexPath.item]
        let userName = aryUserList[indexPath.item]

        cell.imgOfUserView.image = UIImage(named: imgOfUser)
        cell.lblUserName.text = userName
     
        return cell
    }
    //-------------------------------------------------------------
    // MARK: - Tblview Methods
    //-------------------------------------------------------------
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return aryImg.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "userShowViewTableViewCell", for: indexPath) as! userShowViewTableViewCell
             let imgOfUser = aryImg[indexPath.row]
        cell.imgUserViewarProfile.image = UIImage.init(named: imgOfUser)
        
         CountOfUserProfile = aryUserList.count
        
        btnViewCount.setTitle("+\(CountOfUserProfile)", for: .normal)
        return cell
    }

    // MARK:- FSPagerViewDataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 10
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: "emoji1")
        cell.imageView?.contentMode = .center
        cell.imageView?.clipsToBounds = true
       
        
        cell._textLabel?.text = "+12"
        cell._textLabel?.contentMode = .topRight
        cell._textLabel?.backgroundColor = UIColor.red
        
//        cell._textLabel? = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        cell._textLabel?.backgroundColor = UIColor.red
        cell._textLabel?.textAlignment = .center
         cell._textLabel?.textColor = UIColor.white

        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
}




//class DemoCollection: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
//{
//    //-------------------------------------------------------------
//    // MARK: - Outlets
//    //-------------------------------------------------------------
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    //-------------------------------------------------------------
//    // MARK: - viewDidLoad
//    //-------------------------------------------------------------
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//
//    //-------------------------------------------------------------
//    // MARK: - CollectionView Methods
//    //-------------------------------------------------------------
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        return aryUserList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCommentListCollectionViewCell", for: indexPath) as! UserCommentListCollectionViewCell
//
//        let imgOfUser = aryImg[indexPath.item]
//        let userName = aryUserList[indexPath.item]
//
//        cell.imgOfUserView.image = UIImage(named: imgOfUser)
//        cell.lblUserName.text = userName
//
//        return cell
//
//
//        let cella = collectionView.dequeueReusableCell(withReuseIdentifier: "userViewerCollectionViewCell", for: indexPath) as! userViewerCollectionViewCell
//        cella.userimageViewer.image = UIImage(named: aryImg[indexPath.item])
//
//        return cella
//    }
//
//
//
//}

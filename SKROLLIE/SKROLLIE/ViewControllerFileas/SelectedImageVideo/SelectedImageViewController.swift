//
//  SelectedImageViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Jobs on 5/27/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore

class SelectedImageViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var imgSelectedImage: UIImageView!
    @IBOutlet weak var txtEnterDescription: UITextField!
    @IBOutlet weak var emogiPagerView: FSPagerView!
    @IBOutlet weak var btn24Hour: UIButton!
    @IBOutlet weak var btnForever: UIButton!
    @IBOutlet weak var btnEmogi1: UIButton!
    @IBOutlet weak var btnEmogi2: UIButton!
    
    
    //MARK: Properties
    var selectedImage = UIImage()
    var selectedImageUrl: URL!
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        navigationController?.isNavigationBarHidden = true

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        btnEmogi1.setImage(UIImage(named: "icon_question"), for: .normal)
        btnEmogi2.setImage(UIImage(named: "icon_question"), for: .normal)
        
        btn24Hour.setImage(UIImage(named: "icon_24"), for: .normal)
        btnForever.setImage(UIImage(named: "icon_infinite"), for: .normal)
        
        btn24Hour.setImage(UIImage(named: "icon_24")?.sd_tintedImage(with: .yellow), for: .selected)
        btnForever.setImage(UIImage(named: "icon_infinite")?.sd_tintedImage(with: .yellow), for: .selected)
        
        btn24Hour.isSelected = true
        
        txtEnterDescription.becomeFirstResponder()
        setupSwipeGesture()
        setupEmogiPager()
        setData()
    }
    
    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondOnSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        AppDelegate.sharedDelegate().window?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondOnSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        AppDelegate.sharedDelegate().window?.addGestureRecognizer(swipeRight)
    }
    
    private func setupEmogiPager() {
        emogiPagerView.delegate = self
        emogiPagerView.dataSource = self
        self.emogiPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.emogiPagerView.itemSize = CGSize.init(width: 60, height: 40)
        self.emogiPagerView.decelerationDistance = FSPagerView.automaticDistance
        let type = transformerTypes[0]
        self.emogiPagerView.transformer = FSPagerViewTransformer(type:type)
    }
    
    private func setData() {
        imgSelectedImage.image = selectedImage
    }
    
    @objc func respondOnSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                navigationController?.popViewController(animated: false)
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                self.goToHomePage()
                uploadImage(fileUrl: selectedImageUrl)
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    @IBAction func onBtn24Hour(_ sender: Any) {
        btnForever.isSelected = false
        btn24Hour.isSelected = true
    }
    
    @IBAction func onBtnForever(_ sender: Any) {
        btnForever.isSelected = true
        btn24Hour.isSelected = false
    }
    
    @IBAction func onBtnEmogi1(_ sender: Any) {
        if btnEmogi1.image(for: .normal) != UIImage(named: "icon_question") {
            btnEmogi1.setImage(UIImage(named: "icon_question"), for: .normal)
        }
    }
    
    @IBAction func onBtnEmogi2(_ sender: Any) {
        if btnEmogi2.image(for: .normal) != UIImage(named: "icon_question") {
            btnEmogi2.setImage(UIImage(named: "icon_question"), for: .normal)
        }
    }
}


extension SelectedImageViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return arrEmoji.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let currentEmoji = arrEmoji[index]
        
        cell.imageView?.image = currentEmoji
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
        
        let currentEmoji = arrEmoji[index]
        if btnEmogi1.image(for: .normal) == UIImage(named: "icon_question") {
            btnEmogi1.setImage(currentEmoji, for: .normal)
        } else if btnEmogi1.image(for: .normal) != UIImage(named: "icon_question") && btnEmogi2.image(for: .normal) == UIImage(named: "icon_question") {
            btnEmogi2.setImage(currentEmoji, for: .normal)
        }
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
}

extension SelectedImageViewController {
    func goToHomePage() {
        let navVc = AppDelegate.sharedDelegate().window?.rootViewController as! UINavigationController
        for temp in navVc.viewControllers{
            
            if let vc = temp as? HomeViewController{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    func uploadImage(fileUrl : URL) {
        let newKey = "img\(timestamp).jpg"
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.body = fileUrl as URL
        uploadRequest?.key = newKey
        uploadRequest?.bucket = "Jayesh"
        uploadRequest?.contentType = "image/jpeg"
        uploadRequest?.acl = AWSS3ObjectCannedACL.publicRead
        uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            DispatchQueue.main.async(execute: {
                // To show the updating data status in label.
                let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                var dic = [String: Any]()
                dic["uploadProgress"] = uploadProgress
                NotificationCenter.default.post(name: Notification.Name("PROGRESS"), object: nil, userInfo: dic)
                print("ImageUpload -> ", "\(totalBytesExpectedToSend)", "\(totalBytesSent)", "\(uploadProgress)")
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (taskk: AWSTask) -> Any? in
            if taskk.error != nil {
                // Error.
            } else {
                // Do something with your result.
                 self.webserviceOfSavePhoto(name: newKey)
                
                print("done")
            }
            return nil
        })
    }
}

extension SelectedImageViewController
{
    func webserviceOfSavePhoto(name: String)
    {
        var dictdata = [String:AnyObject]()
        
        dictdata[keyAllKey.id] = "0" as AnyObject
        let idpass = (SingleToneClass.sharedInstance.loginDataStore as [String: Any])
        var userId = String()
        if let userIDString = idpass["UserId"] as? String
        {
            userId = "\(userIDString)"
        }
        
        if let userIDInt = idpass["UserId"] as? Int
        {
            userId = "\(userIDInt)"
        }
        dictdata[keyAllKey.KidUser] = userId as AnyObject
        dictdata[keyAllKey.isPhoto] = true as AnyObject
        dictdata[keyAllKey.Url] = "\(name)" as AnyObject
        dictdata[keyAllKey.Description] = txtEnterDescription.text as AnyObject
        dictdata[keyAllKey.Emoji1] = returnEmojiNumber(img: btnEmogi1.image(for: .normal)!) as AnyObject
        dictdata[keyAllKey.Emoji2] = returnEmojiNumber(img: btnEmogi2.image(for: .normal)!) as AnyObject
        dictdata[keyAllKey.isPublish] = true as AnyObject
        dictdata[keyAllKey.Isforever] = btnForever.isSelected ? true as AnyObject : false as AnyObject
    
        webserviceForSavePhoto(dictdata as AnyObject) { (result, status) in
            
            if status
            {
                do
                {
                  
                    AppDelegate.sharedDelegate().window?.showToastAtBottom(message: (result as! [String:AnyObject])["message"] as! String)
                   
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

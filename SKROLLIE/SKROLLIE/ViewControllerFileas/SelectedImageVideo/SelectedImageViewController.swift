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
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.linear,.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]
    var timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private enum SpaceRegion: String {
        case sfo = "sfo2", ams = "ams3", sgp = "sgp1"
        
        var endpointUrl: String {
            return "https://dhaval.sfo2.digitaloceanspaces.com"
        }
    }
    
    func setupUI() {
        navigationController?.isNavigationBarHidden = true
        
        let accessKey = "AFIVAMHKVZGA4FUSWKNY"
        let secretKey = "kP0tXinC+JwAHmH45mQllU1vrKx4MtHdX6BcJD18zWg"
        let regionEndpoint = AWSEndpoint(urlString: SpaceRegion.sfo.endpointUrl)
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: regionEndpoint, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        btn24Hour.isSelected = true
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
        let type = self.transformerTypes[0]
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
        if btnEmogi1.image(for: .normal) != nil {
            btnEmogi1.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func onBtnEmogi2(_ sender: Any) {
        if btnEmogi2.image(for: .normal) != nil {
            btnEmogi2.setImage(nil, for: .normal)
        }
    }
}


extension SelectedImageViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 5
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
        if btnEmogi1.image(for: .normal) == nil {
            btnEmogi1.setImage(UIImage(named: "emoji1"), for: .normal)
        } else if btnEmogi1.image(for: .normal) != nil && btnEmogi2.image(for: .normal) == nil {
            btnEmogi2.setImage(UIImage(named: "emoji1"), for: .normal)
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
        //uploadRequest?.serverSideEncryption = AWSS3ServerSideEncryption.awsKms
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
                
                let url = "https://dhaval.sfo2.digitaloceanspaces.com/Jayesh/\(newKey)"
                 self.webserviceOfSavePhoto(url: url)
                
                print("done")
            }
            return nil
        })
    }
}

extension SelectedImageViewController
{
    func webserviceOfSavePhoto(url: String)
    {
        var dictdata = [String:AnyObject]()
        
        dictdata[keyAllKey.id] = "1" as AnyObject
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
        dictdata[keyAllKey.Url] = "\(url)" as AnyObject
        dictdata[keyAllKey.Description] = txtEnterDescription.text as AnyObject
        dictdata[keyAllKey.Emoji1] = "test" as AnyObject
        dictdata[keyAllKey.Emoji2] = "test" as AnyObject
        dictdata[keyAllKey.isPublish] = true as AnyObject
    
        webserviceForSavePhoto(dictdata as AnyObject) { (result, status) in
            
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

//
//  SelectedVideoViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Jobs on 5/27/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AVKit
import AWSS3
import AWSCore

class SelectedVideoViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var viwVideo: UIView!
    @IBOutlet weak var emogiPager: FSPagerView!
    @IBOutlet weak var txtEnterDescription: UITextField!
    @IBOutlet weak var btn24Hour: UIButton!
    @IBOutlet weak var btnForever: UIButton!
    @IBOutlet weak var btnEmogi1: UIButton!
    @IBOutlet weak var btnEmogi2: UIButton!
    
    //MARK: Properties
    var videoUrl:URL!
    private enum SpaceRegion: String {
        case sfo = "sfo2", ams = "ams3", sgp = "sgp1"
        
        var endpointUrl: String {
            return "https://dhaval.sfo2.digitaloceanspaces.com"
        }
    }
    
    var Timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
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
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Methods
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        
        
        let accessKey = "AFIVAMHKVZGA4FUSWKNY"
        let secretKey = "kP0tXinC+JwAHmH45mQllU1vrKx4MtHdX6BcJD18zWg"
        let regionEndpoint = AWSEndpoint(urlString: SpaceRegion.sfo.endpointUrl)
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: regionEndpoint, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        btnEmogi1.setImage(UIImage(named: "icon_question"), for: .normal)
        btnEmogi2.setImage(UIImage(named: "icon_question"), for: .normal)
        
        btn24Hour.setImage(UIImage(named: "icon_24"), for: .normal)
        btnForever.setImage(UIImage(named: "icon_infinite"), for: .normal)
        
        btn24Hour.setImage(UIImage(named: "icon_24")?.sd_tintedImage(with: .yellow), for: .selected)
        btnForever.setImage(UIImage(named: "icon_infinite")?.sd_tintedImage(with: .yellow), for: .selected)
        
        btn24Hour.isSelected = true

        setupSwipeGesture()
        setupEmogiPager()
        setData()
    }
    
    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        AppDelegate.sharedDelegate().window?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        AppDelegate.sharedDelegate().window?.addGestureRecognizer(swipeRight)
    }
    
    private func setupEmogiPager() {
        emogiPager.delegate = self
        emogiPager.dataSource = self
        self.emogiPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.emogiPager.itemSize = CGSize.init(width: 60, height: 40)
        self.emogiPager.decelerationDistance = FSPagerView.automaticDistance
        let type = self.transformerTypes[0]
        self.emogiPager.transformer = FSPagerViewTransformer(type:type)
    }
    
    private func setData() {
        let playerItem = AVPlayerItem(url: videoUrl)
        let avPlayer = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame.size = UIScreen.main.bounds.size
        playerLayer.videoGravity = .resizeAspectFill
        viwVideo.layer.addSublayer(playerLayer)
        avPlayer.play()
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveImageDocumentDirectory(image: UIImage) -> URL
    {
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(Timestamp)Imag.jpeg")
        if let imageData = UIImage.jpegData(image)(compressionQuality: 0.3) {
            fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
        }
        return URL(fileURLWithPath: path)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
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
                uploadVideo(fileUrl: videoUrl)
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    @IBAction func onBtn24Hour(_ sender: Any) {
        btn24Hour.isSelected = true
        btnForever.isSelected = false
    }
    
    @IBAction func onBtnForever(_ sender: Any) {
        btn24Hour.isSelected = false
        btnForever.isSelected = true
    }
    
    @IBAction func onBtnEmogi1(_ sender: Any) {
        if btnEmogi1.image(for: .normal) == UIImage(named: "emoji1") {
            btnEmogi1.setImage(UIImage(named: "icon_question"), for: .normal)
        }
    }
    
    @IBAction func onBtnEmogi2(_ sender: Any) {
        if btnEmogi2.image(for: .normal) == UIImage(named: "emoji1") {
            btnEmogi2.setImage(UIImage(named: "icon_question"), for: .normal)
        }
    }
}

extension SelectedVideoViewController: FSPagerViewDelegate, FSPagerViewDataSource {
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
        cell._textLabel?.textAlignment = .center
        cell._textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if btnEmogi1.image(for: .normal) == UIImage(named: "icon_question") {
            btnEmogi1.setImage(UIImage(named: "emoji1"), for: .normal)
        } else if btnEmogi1.image(for: .normal) != UIImage(named: "icon_question") && btnEmogi2.image(for: .normal) == UIImage(named: "icon_question") {
            btnEmogi2.setImage(UIImage(named: "emoji1"), for: .normal)
        }
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
}

extension SelectedVideoViewController {
    func goToHomePage() {
        let navVc = AppDelegate.sharedDelegate().window?.rootViewController as! UINavigationController
        for temp in navVc.viewControllers{
            
            if let vc = temp as? HomeViewController{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    func uploadVideo(fileUrl : URL) {
        let newKey = "video\(timestamp).mov"
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.body = fileUrl as URL
        uploadRequest?.key = newKey
        uploadRequest?.bucket = "Jayesh"
        uploadRequest?.acl = AWSS3ObjectCannedACL.publicRead
        uploadRequest?.contentType = "movie/mov"
        
        uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            DispatchQueue.main.async(execute: {
                let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                var dic = [String: Any]()
                dic["uploadProgress"] = uploadProgress
                NotificationCenter.default.post(name: Notification.Name("PROGRESS"), object: nil, userInfo: dic)
                print("VideoUpload -> ", "\(totalBytesExpectedToSend)", "\(totalBytesSent)", "\(uploadProgress)")
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task) in
            if task.error != nil {
                print(task.error.debugDescription)
            } else {
                // Do something with your result.
                
                let thumbImg = self.createThumbnailOfVideoFromRemoteUrl(url: fileUrl)
                let thumbUrl = self.saveImageDocumentDirectory(image: thumbImg!)
                self.uploadImage(fileUrl: thumbUrl, videoName: newKey)
                print("done Video upload")
            }
            return nil
        })
    }
    
    func uploadImage(fileUrl : URL, videoName: String) {
        let newKey = "imgThumb\(timestamp).jpg"
        
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
                print("ImageThumbUpload -> ", "\(totalBytesExpectedToSend)", "\(totalBytesSent)", "\(uploadProgress)")
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (taskk: AWSTask) -> Any? in
            if taskk.error != nil {
                // Error.
            } else {
                // Do something with your result.
                self.webserviceOfSaveVideo(name: videoName, thumbImgName: newKey)
                print("done Thumbnil")
            }
            return nil
        })
    }
}
extension SelectedVideoViewController
{
    func webserviceOfSaveVideo(name: String, thumbImgName: String)
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
        dictdata[keyAllKey.isPhoto] = false as AnyObject
        dictdata[keyAllKey.Url] = "\(name)" as AnyObject
        dictdata[keyAllKey.Description] = txtEnterDescription.text as AnyObject
        dictdata[keyAllKey.Videothumbnailimage] = "\(thumbImgName)" as AnyObject
        dictdata[keyAllKey.Emoji1] = "10" as AnyObject
        dictdata[keyAllKey.Emoji2] = "10" as AnyObject
        dictdata[keyAllKey.isPublish] = true as AnyObject
        dictdata[keyAllKey.Isforever] = btn24Hour.isSelected ? true as AnyObject : false as AnyObject
        
        webserviceForSavePhoto(dictdata as AnyObject) { (result, status) in
            
            if status
            {
                do
                {
                    self.view.showToastAtBottom(message: (result as! [String:AnyObject])["message"] as! String)
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

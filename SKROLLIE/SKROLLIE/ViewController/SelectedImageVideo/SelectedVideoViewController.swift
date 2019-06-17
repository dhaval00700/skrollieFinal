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
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnText: UIButton!
    @IBOutlet weak var viwDesc: UIView!
    @IBOutlet weak var btnEmogiHide: UIButton!
    
    //MARK: Properties
    var videoUrl:URL!
    var avPlayer = AVPlayer()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Methods
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        btnEmogi1.setImage(UIImage(named: "blankHappy"), for: .normal)
        btnEmogi2.setImage(UIImage(named: "blankSad"), for: .normal)
        
        btn24Hour.setImage(UIImage(named: "icon_24"), for: .normal)
        btnForever.setImage(UIImage(named: "icon_infinite"), for: .normal)
        
        btn24Hour.setImage(UIImage(named: "icon_24")?.tintWithColor(.yellow), for: .selected)
        btnForever.setImage(UIImage(named: "icon_infinite")?.tintWithColor(.yellow), for: .selected)
        
        btnText.addCornerRadius(btnText.frame.height/2.0)
        btnEmogiHide.addCornerRadius(btnEmogiHide.frame.height/2.0)
        
        btnPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        btnPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .selected)
        
        btn24Hour.isSelected = true
        btnPlayPause.isSelected = true
        
        viwDesc.isHidden = true
        emogiPager.isHidden = true
        btnEmogiHide.isHidden = true
        
        setupSwipeGesture()
        setupEmogiPager()
        setData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.avPlayer.play()
        }
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
        let type = transformerTypes[0]
        self.emogiPager.transformer = FSPagerViewTransformer(type:type)
    }
    
    private func setData() {
        let playerItem = AVPlayerItem(url: videoUrl)
        avPlayer = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame.size = UIScreen.main.bounds.size
        playerLayer.videoGravity = .resize
        viwVideo.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        btnPlayPause.isSelected = false
        setData()
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
    
    func saveImageDocumentDirectory(image: UIImage) -> URL {
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(timestamp)Imag.jpeg")
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
        emogiPager.isHidden = false
        btnEmogiHide.isHidden = false
        if btnEmogi1.image(for: .normal) != UIImage(named: "blankHappy") {
            btnEmogi1.setImage(UIImage(named: "blankHappy"), for: .normal)
        }
    }
    
    @IBAction func onBtnEmogi2(_ sender: Any) {
        emogiPager.isHidden = false
        btnEmogiHide.isHidden = false
        if btnEmogi2.image(for: .normal) != UIImage(named: "blankSad") {
            btnEmogi2.setImage(UIImage(named: "blankSad"), for: .normal)
        }
    }
    
    @IBAction func onBtnPlayPause(_ sender: Any) {
        
        if btnPlayPause.isSelected  {
            avPlayer.pause()
            btnPlayPause.isSelected = false
        } else {
            avPlayer.play()
            btnPlayPause.isSelected = true
        }
    }
    
    @IBAction func onBtnText(_ sender: Any) {
        viwDesc.isHidden = !viwDesc.isHidden
    }
    
    @IBAction func onBtnEmogiHide(_ sender: Any) {
        emogiPager.isHidden = true
        btnEmogiHide.isHidden = true
    }
}

extension SelectedVideoViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return arrEmoji.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let currentEmoji = arrEmoji[index]
        cell.imageView?.image = currentEmoji
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let currentEmoji = arrEmoji[index]
        if btnEmogi1.image(for: .normal) == UIImage(named: "blankHappy") {
            btnEmogi1.setImage(currentEmoji, for: .normal)
        } else if btnEmogi1.image(for: .normal) != UIImage(named: "blankHappy") && btnEmogi2.image(for: .normal) == UIImage(named: "blankSad") {
            btnEmogi2.setImage(currentEmoji, for: .normal)
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

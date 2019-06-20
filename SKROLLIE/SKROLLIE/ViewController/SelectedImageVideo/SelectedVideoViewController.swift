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
    @IBOutlet weak var txtEnterDescription: UITextView!
    @IBOutlet weak var btn24Hour: UIButton!
    @IBOutlet weak var btnForever: UIButton!
    @IBOutlet weak var btnEmogi1: UIButton!
    @IBOutlet weak var btnEmogi2: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnText: UIButton!
    @IBOutlet weak var btnEmogiHide: UIButton!
    @IBOutlet weak var btnMuteControll: UIButton!
    
    @IBOutlet weak var lctEnterDescriptionHeight: NSLayoutConstraint!

    
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
        btnMuteControll.addCornerRadius(btnMuteControll.frame.height/2.0)
        btnEmogiHide.addCornerRadius(btnEmogiHide.frame.height/2.0)
        
        btnPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        btnPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .selected)
        
        btn24Hour.isSelected = true
        btnPlayPause.isSelected = true
        
        txtEnterDescription.isHidden = true
        emogiPager.isHidden = true
        btnEmogiHide.isHidden = true
        
        btnMuteControll.setImage(#imageLiteral(resourceName: "Unmute"), for: .normal)
        btnMuteControll.setImage(#imageLiteral(resourceName: "Mute"), for: .selected)
        
        txtEnterDescription.applyBorder(1.0, borderColor: .black)
        txtEnterDescription.addCornerRadius(8.0)
        
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
        self.emogiPager.itemSize = CGSize(width: 50, height: 50)
        self.emogiPager.interitemSpacing = 8
        let type = transformerTypes[0]
        self.emogiPager.transformer = FSPagerViewTransformer(type:type)
    }
    
    private func setData() {
        let playerItem = AVPlayerItem(url: videoUrl)
        avPlayer = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame.size = UIScreen.main.bounds.size
        playerLayer.videoGravity = .resizeAspect
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
                let emoji1 = returnEmojiNumber(img: self.btnEmogi1.image(for: .normal)!)
                let emoji2 = returnEmojiNumber(img: self.btnEmogi2.image(for: .normal)!)
                if (!emoji1.isEmpty && emoji2.isEmpty) || (emoji1.isEmpty && !emoji2.isEmpty) {
                    AppDelegate.sharedDelegate().window?.showToastAtBottom(message:"Please Select Both Emoji")
                } else {
                    self.goToHomePage()
                    uploadVideo(fileUrl: videoUrl)
                }
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
        txtEnterDescription.isHidden = !txtEnterDescription.isHidden
        if !txtEnterDescription.becomeFirstResponder() {
            txtEnterDescription.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
    }
    
    @IBAction func onBtnMuteControll(_ sender: Any) {
        btnMuteControll.isSelected = !btnMuteControll.isSelected
        avPlayer.isMuted = !avPlayer.isMuted
    }
    
    @IBAction func onBtnEmogiHide(_ sender: Any) {
        let emoji1 = returnEmojiNumber(img: self.btnEmogi1.image(for: .normal)!)
        let emoji2 = returnEmojiNumber(img: self.btnEmogi2.image(for: .normal)!)
        if (!emoji1.isEmpty && emoji2.isEmpty) || (emoji1.isEmpty && !emoji2.isEmpty) {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message:"Please Select Both Emoji")
        }
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
        } else if btnEmogi1.image(for: .normal) != UIImage(named: "blankHappy") && btnEmogi2.image(for: .normal) == UIImage(named: "blankSad") && btnEmogi1.image(for: .normal) != currentEmoji {
            btnEmogi2.setImage(currentEmoji, for: .normal)
        } else {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Please Select Different Emoji")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
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
                self.SavePhoto(name: videoName, thumbImgName: newKey)
                print("done Thumbnil")
            }
            return nil
        })
    }
}
extension SelectedVideoViewController
{
    
    func SavePhoto(name: String, thumbImgName: String) {
        
        
        let parameter = ParameterRequest()
        parameter.addParameter(key: ParameterRequest.id, value: "0")
        parameter.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserData().UserId)
        parameter.addParameter(key: ParameterRequest.isPhoto, value: false)
        parameter.addParameter(key: ParameterRequest.Url, value: name)
        parameter.addParameter(key: ParameterRequest.Description, value: txtEnterDescription.text)
        parameter.addParameter(key: ParameterRequest.Videothumbnailimage, value: thumbImgName)
        parameter.addParameter(key: ParameterRequest.Emoji1, value: returnEmojiNumber(img: btnEmogi1.image(for: .normal)!))
        parameter.addParameter(key: ParameterRequest.Emoji2, value: returnEmojiNumber(img: btnEmogi2.image(for: .normal)!))
        parameter.addParameter(key: ParameterRequest.isPublish, value: true)
        parameter.addParameter(key: ParameterRequest.Isforever, value: btnForever.isSelected ? true as AnyObject : false)
        
        
        _ = APIClient.SavePostImage(parameters: parameter.parameters, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                let loginModel = LoginModel(data: response)
                
                AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
                AppPrefsManager.shared.saveUserData(model: loginModel)
                
                let vc = HomeViewController.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if !responseData.success {
                if responseData.message == "OTP" {
                    AppDelegate.sharedDelegate().window?.showToastAtBottom(message: responseData.message)
                    
                } else {
                    
                }
            }
        })
    }
    
}



extension SelectedVideoViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if(textView == txtEnterDescription) {
            let contentSize = txtEnterDescription.sizeThatFits(CGSize(width: txtEnterDescription.bounds.size.width, height: CGFloat(Float.greatestFiniteMagnitude)))
            lctEnterDescriptionHeight.constant = CGFloat(ceilf(Float(contentSize.height)))
            textView.layoutIfNeeded()
            textView.updateConstraints()
            textView.scrollRangeToVisible(textView.selectedRange)
            
        }
    }
}

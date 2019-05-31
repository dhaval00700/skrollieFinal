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
        if btnEmogi1.image(for: .normal) == nil {
            btnEmogi1.setImage(UIImage(named: "emoji1"), for: .normal)
        } else if btnEmogi1.image(for: .normal) != nil && btnEmogi2.image(for: .normal) == nil {
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
                let amountUploaded = totalBytesSent // To show the updating data status in label.
                print(amountUploaded)
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task) in
            if task.error != nil {
                print(task.error.debugDescription)
            } else {
                // Do something with your result.
                self.goToHomePage()
                print("done")
            }
            return nil
        })
        
    }
}

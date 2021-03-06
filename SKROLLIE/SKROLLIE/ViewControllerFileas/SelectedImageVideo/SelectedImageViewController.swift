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
    @IBOutlet weak var emogiPagerView: FSPagerView!
    
    
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
                uploadImage(fileUrl: selectedImageUrl)
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
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
                print("\(totalBytesSent)")
                print("\(totalBytesExpectedToSend)")
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (taskk: AWSTask) -> Any? in
            if taskk.error != nil {
                // Error.
            } else {
                // Do something with your result.
                self.goToHomePage()
                print("done")
            }
            return nil
        })
        
        /*let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task) in
            if task.error != nil {
                print(task.error.debugDescription)
            } else {
                // Do something with your result.
                self.goToHomePage()
                print("done")
            }
            return nil
        })*/
        
    }
}


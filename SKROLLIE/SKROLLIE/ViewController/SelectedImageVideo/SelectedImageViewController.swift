//
//  SelectedImageViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Jobs on 5/27/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AVKit
import AWSS3
import AWSCore

class SelectedImageViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imgSelectedImage: UIImageView!
    @IBOutlet weak var txtEnterDescription: UITextView!
    @IBOutlet weak var emogiPagerView: FSPagerView!
    @IBOutlet weak var btn24Hour: UIButton!
    @IBOutlet weak var btnForever: UIButton!
    @IBOutlet weak var btnEmogi1: UIButton!
    @IBOutlet weak var btnEmogi2: UIButton!
    @IBOutlet weak var btnText: UIButton!
    @IBOutlet weak var btnEmogiHide: UIButton!
    
    @IBOutlet weak var lctEnterDescriptionHeight: NSLayoutConstraint!

    
    
    // MARK: - Properties
    var selectedImage = UIImage()
    var selectedImageUrl: URL!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        navigationController?.isNavigationBarHidden = true
        
        btnText.addCornerRadius(btnText.frame.height/2.0)
        btnEmogiHide.addCornerRadius(btnEmogiHide.frame.height/2.0)
        
        txtEnterDescription.addCornerRadius(8.0)
        txtEnterDescription.applyBorder(1.0, borderColor: .black)
        
        txtEnterDescription.isHidden = true
        emogiPagerView.isHidden = true
        btnEmogiHide.isHidden = true
        
        btnEmogi1.setImage(UIImage(named: "blankHappy"), for: .normal)
        btnEmogi2.setImage(UIImage(named: "blankSad"), for: .normal)
        
        btn24Hour.setImage(UIImage(named: "icon_24"), for: .normal)
        btnForever.setImage(UIImage(named: "icon_infinite"), for: .normal)
        
        btn24Hour.setImage(UIImage(named: "icon_24")?.tintWithColor(.yellow), for: .selected)
        btnForever.setImage(UIImage(named: "icon_infinite")?.tintWithColor(.yellow), for: .selected)
        
        btn24Hour.isSelected = true
        
        txtEnterDescription.delegate = self
        imgSelectedImage.isUserInteractionEnabled = true
        
        setupSwipeGesture()
        setupEmogiPager()
        setData()
    }
    
    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondOnSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        imgSelectedImage.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondOnSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        imgSelectedImage.addGestureRecognizer(swipeRight)
    }
    
    private func setupEmogiPager() {
        emogiPagerView.delegate = self
        emogiPagerView.dataSource = self
        self.emogiPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.emogiPagerView.itemSize = CGSize(width: 50, height: 50)
        self.emogiPagerView.interitemSpacing = 8
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
                let emoji1 = returnEmojiNumber(img: self.btnEmogi1.image(for: .normal)!)
                let emoji2 = returnEmojiNumber(img: self.btnEmogi2.image(for: .normal)!)
                if (!emoji1.isEmpty && emoji2.isEmpty) || (emoji1.isEmpty && !emoji2.isEmpty) {
                    AppDelegate.sharedDelegate().window?.showToastAtBottom(message:"Please Select Both Emoji")
                } else {
                    let navVc = userProfileClass.instantiate(fromAppStoryboard: .Main)
                    navigationController?.pushViewController(navVc, animated: true)
                    uploadImage(fileUrl: selectedImageUrl)
                }
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    @IBAction func onBtnText(_ sender: Any) {
        txtEnterDescription.isHidden = !txtEnterDescription.isHidden
        if txtEnterDescription.isHidden {
            self.view.endEditing(true)
        } else {
            txtEnterDescription.becomeFirstResponder()
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
        emogiPagerView.isHidden = false
        btnEmogiHide.isHidden = false
        if btnEmogi1.image(for: .normal) != UIImage(named: "blankHappy") {
            btnEmogi1.setImage(UIImage(named: "blankHappy"), for: .normal)
        }
    }
    
    @IBAction func onBtnEmogi2(_ sender: Any) {
        emogiPagerView.isHidden = false
        btnEmogiHide.isHidden = false
        if btnEmogi2.image(for: .normal) != UIImage(named: "blankSad") {
            btnEmogi2.setImage(UIImage(named: "blankSad"), for: .normal)
        }
    }
    @IBAction func onBtnHide(_ sender: Any) {
        let emoji1 = returnEmojiNumber(img: btnEmogi1.image(for: .normal)!)
        let emoji2 = returnEmojiNumber(img: btnEmogi2.image(for: .normal)!)
        if (!emoji1.isEmpty && emoji2.isEmpty) || (emoji1.isEmpty && !emoji2.isEmpty) {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message:"Please Select Both Emoji")
        }
        emogiPagerView.isHidden = true
        btnEmogiHide.isHidden = true
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

extension SelectedImageViewController {
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
                NotificationCenter.default.post(name: PROGRESS_NOTIFICATION_KEY, object: nil, userInfo: dic)
                print("ImageUpload -> ", "\(totalBytesExpectedToSend)", "\(totalBytesSent)", "\(uploadProgress)")
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (taskk: AWSTask) -> Any? in
            if taskk.error != nil {
                // Error.
            } else {
                // Do something with your result.
                 self.SavePhoto(name: newKey)
                
                print("done")
            }
            return nil
        })
    }
}

extension SelectedImageViewController
{
    
    private func SavePhoto(name: String) {
    
        
        let parameter = ParameterRequest()
        parameter.addParameter(key: ParameterRequest.id, value: "0")
        parameter.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserData().UserId)
        parameter.addParameter(key: ParameterRequest.isPhoto, value: true)
        parameter.addParameter(key: ParameterRequest.Url, value: name)
        parameter.addParameter(key: ParameterRequest.Description, value: txtEnterDescription.text)
        parameter.addParameter(key: ParameterRequest.Emoji1, value: returnEmojiNumber(img: btnEmogi1.image(for: .normal)!))
        parameter.addParameter(key: ParameterRequest.Emoji2, value: returnEmojiNumber(img: btnEmogi2.image(for: .normal)!))
        parameter.addParameter(key: ParameterRequest.isPublish, value: true)
        parameter.addParameter(key: ParameterRequest.Isforever, value: btnForever.isSelected ? true as AnyObject : false)

        
        _ = APIClient.SavePostImage(parameters: parameter.parameters, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                NotificationCenter.default.post(name: REFRESH_NOTIFICATION_KEY, object: nil)
                //AppDelegate.sharedDelegate().window?.showToastAtBottom(message: responseData.message)
            }
        })
    }
    
   
}



extension SelectedImageViewController : UITextViewDelegate {
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

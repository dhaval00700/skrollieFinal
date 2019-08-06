//
//  EditProfileViewController.swift
//  SKROLLIE
//
//  Created by PC on 02/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KMPlaceholderTextView
import MobileCoreServices
import AWSS3
import AWSCore


class EditProfileViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var viwBackground: UIView!
    @IBOutlet weak var imgUserPic: UIImageView!
    @IBOutlet weak var lblUserTag: UILabel!
    @IBOutlet weak var imgUserTag: UIImageView!
    @IBOutlet weak var txtUsername: SkyFloatingLabelTextField!
    @IBOutlet weak var txvDesc: KMPlaceholderTextView!
    @IBOutlet weak var lctTxvDesc: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnChangeProfilePic: UIButton!
    
    // MARK: - Properties
    private var newKey = ""
    public var superVc = userProfileClass()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        viwBackground.addGestureRecognizer(tapGesture)
        txtUsername.delegate = self
        txvDesc.delegate = self
        btnSubmit.addCornerRadius(btnSubmit.frame.height/2.0)
        txvDesc.applyBorder(0.8, borderColor: #colorLiteral(red: 0.9687328935, green: 0.6965460181, blue: 0.2085384429, alpha: 1))
        txvDesc.addCornerRadius(10)
        imgUserTag.image = #imageLiteral(resourceName: "ic_shield").tintWithColor(#colorLiteral(red: 0.9687328935, green: 0.6965460181, blue: 0.2085384429, alpha: 1))
        imgUserTag.isHidden = true
        setData()
    }
    
    private func setData() {
        let userProfileData = AppPrefsManager.shared.getUserProfileData()
        if userProfileData.IsAccountVerify == AccountVerifyStatus.zero || userProfileData.IsAccountVerify == AccountVerifyStatus.one {
            imgUserTag.isHidden = true
        } else {
            imgUserTag.isHidden = false
        }
        imgUserPic.imageFromURL(link: userProfileData.image, errorImage: postPlaceHolder, contentMode: .scaleAspectFill)
        lblUserTag.text = "@" + userProfileData.username
        txtUsername.text = userProfileData.ProfileName
        txvDesc.text = userProfileData.description
    }
    
    // MARK: - Actions
    @objc func onTap() {
        self.dismiss(animated: true, completion: {
            self.superVc.viewWillAppear(true)
        })
    }
    @IBAction func onBtnSubmit(_ sender: Any) {
        updateData()
    }
    
    @IBAction func onBtnChangeProfilePic(_ sender: Any) {
        selectImage()
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        onTap()
    }
}

extension EditProfileViewController {
    private func uploadImage(fileUrl : URL) {
        newKey = "img\(timestamp).jpg"
        
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
                print("ImageUpload -> ", "\(totalBytesExpectedToSend)", "\(totalBytesSent)", "\(uploadProgress)")
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (taskk: AWSTask) -> Any? in
            if taskk.error != nil {
                // Error.
            } else {
                // Do something with your result.
                
                print("done")
            }
            return nil
        })
    }
    
    private func updateData() {
        let parameter = ParameterRequest()
        parameter.addParameter(key: ParameterRequest.id, value: AppPrefsManager.shared.getUserData().UserId)
        if !newKey.isEmpty {
            parameter.addParameter(key: ParameterRequest.image, value: newKey)
        }
        parameter.addParameter(key: ParameterRequest.ProfileName, value: txtUsername.text!.encode())
        parameter.addParameter(key: ParameterRequest.description, value: txvDesc.text.encode())
        
        updateUserProfileData(parameters: parameter.parameters) { (flg) in
            if flg {
                self.setData()
                self.onTap()
                AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Profile Updated!")
            }
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let urlImg = saveImageDocumentDirectory(image: editedImage)
            self.imgUserPic.image = editedImage
            uploadImage(fileUrl: urlImg)
            print("image")
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let urlImg = saveImageDocumentDirectory(image: originalImage)
            self.imgUserPic.image = originalImage
            uploadImage(fileUrl: urlImg)
            print("Video")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Photo selection methods
    @objc func selectImage() {
        view.endEditing(true)
        
        var alertController = UIAlertController()
        
        alertController.popoverPresentationController?.sourceView = imgUserPic
        alertController.popoverPresentationController?.sourceRect = imgUserPic.bounds
        alertController = UIAlertController(title: "Task Media", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Take a Media", style: .default, handler: { (action) -> Void in
            DispatchQueue.main.async {
                self.loadCameraView()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Choose from Existing", style: .default, handler: { (action) -> Void in
            DispatchQueue.main.async {
                self.loadPhotoGalleryView()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel".uppercased(), style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func loadCameraView() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.navigationBar.tintColor =  #colorLiteral(red: 0.2352941176, green: 0.5098039216, blue: 0.6666666667, alpha: 1)
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            imagePickerController.delegate = self
            imagePickerController.showsCameraControls = true
            present(imagePickerController, animated: true, completion: nil)
        } else {
            Utility.showMessageAlert(title: "Error", andMessage: "Camera option does not available with this device.", withOkButtonTitle: "OK")
        }
    }
    
    func loadPhotoGalleryView() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .savedPhotosAlbum
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            imagePickerController.delegate = self
            
            
            present(imagePickerController, animated: true, completion: nil)
        } else {
            Utility.showMessageAlert(title: "Error", andMessage: "Photo library does not avaialable on this device.", withOkButtonTitle: "OK")
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == txtUsername)
        {
            let finalString = (textField.text! as NSString).replacingCharacters(in: range, with: string).encode()
            
            if finalString.contains("\\u2714\\ufe0f") {
                return false
            }
            if finalString.contains("\\u2611\\ufe0f") {
                return false
            }
            if finalString.contains("\\u2705") {
                return false
            }
            if finalString.count > 30 {
                return false
            }
        }
        return true
    }
}


extension EditProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(textView == txvDesc)
        {
            let finalString = (textView.text! as NSString).replacingCharacters(in: range, with: text).encode()
            
            if finalString.contains("\\u2714\\ufe0f") {
                return false
            }
            if finalString.contains("\\u2611\\ufe0f") {
                return false
            }
            if finalString.contains("\\u2705") {
                return false
            }
            if finalString.count > 250 {
                return false
            }
        }
        return true
    }
}

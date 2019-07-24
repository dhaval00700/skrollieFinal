//
//  VerificationBadgeViewController.swift
//  SKROLLIE
//
//  Created by PC on 01/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import MobileCoreServices
import AWSS3
import AWSCore

class VerificationBadgeViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var viwBackground: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var lblUserNameTitle: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFullNameTitle: UILabel!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var lblAkaTitle: UILabel!
    @IBOutlet weak var txtAka: UITextField!
    @IBOutlet weak var lblAttachPhotoTitle: UILabel!
    @IBOutlet weak var btnUploadPhoto: UIButton!
    @IBOutlet weak var lblConclusion: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    // MARK: - Properties
    private var newKey = ""
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    // MARK: - Functions
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        viwBackground.addGestureRecognizer(tapGesture)
        btnSubmit.addCornerRadius(btnSubmit.frame.height/2.0)
        btnUploadPhoto.setTitle("Upload ID", for: .normal)
        
        setData()
    }
    
    private func setData() {
        lblUserName.text = AppPrefsManager.shared.getUserProfileData().username
    }
    
    private func isValid() -> Bool {
        if txtFullName.text != nil && txtFullName.text!.isEmpty {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Enter full name")
            return false
        } else if newKey.isEmpty {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Select Id photo")
            return false
        }
        return true
    }
    
    // MARK: - Actions
    @objc func onTap() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onBtnUploadPhoto(_ sender: Any) {
        selectImage()
    }
    
    @IBAction func onBtnSubmit(_ sender: Any) {
        if isValid() {
            updateData()
        }
    }
    
    @IBAction func onBtnDrag(_ sender: Any) {
        onTap()
    }
}

extension VerificationBadgeViewController {
    private func uploadImage(fileUrl : URL) {
        newKey = "img\(timestamp).jpg"
        btnUploadPhoto.setTitle(newKey, for: .normal)
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
        parameter.addParameter(key: ParameterRequest.image, value: newKey)
        parameter.addParameter(key: ParameterRequest.FullName, value: txtFullName.text)
        parameter.addParameter(key: ParameterRequest.AKA, value: txtAka.text)
        
        updateUserProfileData(parameters: parameter.parameters) { (flg) in
            if flg {
                AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Account verification request sent!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension VerificationBadgeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let urlImg = saveImageDocumentDirectory(image: editedImage)
            uploadImage(fileUrl: urlImg)
            print("image")
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let urlImg = saveImageDocumentDirectory(image: originalImage)
            uploadImage(fileUrl: urlImg)
            print("Video")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Photo selection methods
    @objc func selectImage() {
        view.endEditing(true)
        
        var alertController = UIAlertController()
        
        alertController.popoverPresentationController?.sourceView = btnUploadPhoto
        alertController.popoverPresentationController?.sourceRect = btnUploadPhoto.bounds
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
            imagePickerController.allowsEditing = true
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
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            
            
            present(imagePickerController, animated: true, completion: nil)
        } else {
            Utility.showMessageAlert(title: "Error", andMessage: "Photo library does not avaialable on this device.", withOkButtonTitle: "OK")
        }
    }
}


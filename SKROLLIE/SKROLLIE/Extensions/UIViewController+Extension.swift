//
//  UIViewController+Extension.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    
    func showToastAtBottom(message: String) {
        self.view.showToastAtBottom(message: message)
    }
    
    func showToastAtTop(message: String) {
        self.view.showToastAtTop(message: message)
    }
}

/*extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("image")
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Video")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func selectedMedia(obj: @escaping(UIImage, URL) -> Void) {
        
    }
    
    //Photo selection methods
    func selectImage(view: UIView) {
        view.endEditing(true)
        
        var alertController = UIAlertController()
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.bounds
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
            imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            imagePickerController.showsCameraControls = true
            present(imagePickerController, animated: true, completion: nil)
        } else {
            Utility.showMessageAlert(title: "Error", andMessage: "Camera option does not available with this device.", withOkButtonTitle: "OK")
        }
    }
    
    func loadPhotoGalleryView() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            
            
            present(imagePickerController, animated: true, completion: nil)
        } else {
            Utility.showMessageAlert(title: "Error", andMessage: "Photo library does not avaialable on this device.", withOkButtonTitle: "OK")
        }
    }
}*/


enum AppStoryboard : String {
    
    case Main
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

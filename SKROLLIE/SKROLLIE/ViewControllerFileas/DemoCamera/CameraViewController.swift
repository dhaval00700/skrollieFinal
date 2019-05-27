//
//  CameraViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 5/16/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AVKit
import CoreMedia

import Photos

class CameraViewController: UIViewController {
    // MARK: Members
    
    let cameraManager       = PGMCameraKit()
    let helper              = PGMCameraKitHelper()
    var player: AVPlayer!
    
    
    // MARK: @IBOutlets
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
//    @IBOutlet weak var flashModeButton: UIButton!
    @IBOutlet weak var interfaceView: UIView!
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        if currentCameraState == .NotDetermined || currentCameraState == .AccessDenied {
            
            print("We don't have permission to use the camera.")
            
            cameraManager.askUserForCameraPermissions(completition: { [unowned self] permissionGranted in
                
                if permissionGranted {
                    self.addCameraToView()
                }
                else {
                    self.addCameraAccessDeniedPopup(message: "Go to settings and grant acces to the camera device to use it.")
                }
            })
        }
        else if (currentCameraState == .Ready) {
            
            addCameraToView()
        }
 
//
//        if !cameraManager.hasFlash {
//
//            flashModeButton.isEnabled = false
//            flashModeButton.setTitle("No flash", for: UIControl.State.normal)
//        }
        // Limits
        cameraManager.maxRecordedDuration = 60
        // Listeners
        cameraManager.addCameraErrorListener( cameraError: { [unowned self] error in
            
            if let err = error {
                
                if err.code == CameraError.CameraAccessDeniend.rawValue {
                    
                    self.addCameraAccessDeniedPopup(message: err.localizedFailureReason!)
                }
            }
        })
        
        cameraManager.addCameraTimeListener( cameraTime: { time in
            
            print("Time elapsed: \(time) seg")
        })
        
        cameraManager.addMaxAllowedLengthListener(cameraMaxAllowedLength: { [unowned self] (videoURL, error, localIdentifier) -> () in
            
            if let err = error {
                print("Error \(err)")
            }
            else {
                
                if let url = videoURL {
                    
                    print("Saved video from local url \(url) with uuid \(localIdentifier)")
                    
                    let data = NSData(contentsOf: url as URL)!
                    
                    print("Byte Size Before Compression: \(data.length / 1024) KB")
                    
                    // The compress file extension will depend on the output file type
                    self.helper.compressVideo(inputURL: url as URL, outputURL: self.cameraManager.tempCompressFilePath(ext: "mp4"), outputFileType: AVFileType.mp4.rawValue, handler: { session in
                        
                        if let currSession = session {
                            
                            print("Progress: \(currSession.progress)")
                            
                            print("Save to \(currSession.outputURL)")
                            
                            if currSession.status == .completed {
                                
                                if let data = NSData(contentsOf: currSession.outputURL!) {
                                    
                                    print("File size after compression: \(data.length / 1024) KB")
                                    
                                    // Play compressed video
                                    DispatchQueue.main.async {
                                        
                                        let player  = AVPlayer(url: currSession.outputURL!)
                                        let layer   = AVPlayerLayer(player: player)
                                        layer.frame = self.view.bounds
                                        self.view.layer.addSublayer(layer)
                                        player.play()
                                        
                                        print("Playing video...")
                                    }
                                }
                            }
                            else if currSession.status == .failed
                            {
                                print(" There was a problem compressing the video maybe you can try again later. Error: \(currSession.error!.localizedDescription)")
                            }
                        }
                    })
                }
            }
            
            // Recording stopped automatically after reached max allowed duration
            self.cameraButton.isSelected = !(self.cameraButton.isSelected)
            self.cameraButton.setTitle("", for: .selected)
            self.cameraButton.backgroundColor = self.cameraButton.isSelected ? UIColor.red : UIColor.green
        })
        
        let vedio = UITapGestureRecognizer(target: self, action: #selector(TappedForPhotos))
        vedio.numberOfTapsRequired = 1
        if vedio.numberOfTapsRequired == 1
        {
           
        }
        cameraView.addGestureRecognizer(vedio)
        
        //Photo
        
        let Photo = UITapGestureRecognizer(target: self, action: #selector(startCapture))
        Photo.numberOfTapsRequired = 2
        if Photo.numberOfTapsRequired == 2
        {
            
        }
        cameraView.addGestureRecognizer(Photo)
        
        vedio.require(toFail: Photo)
   //     cameraManager.cameraOutputMode = .StillImage
        self.view.bringSubviewToFront(cameraButton)
        
    }
    @objc func TappedForPhotos()
    {
//        cameraManager.capturePictureWithCompletition( imageCompletition: { (image, error, localIdentifier) -> () in
//
//            if let err = error {
//                print("Error ocurred: \(err)")
//            }
//            else {
//                print("Image saved to library to id: \(localIdentifier)")
//            }
//
//        }, name: "ImageName")
        
        cameraManager.stopRecordingVideo( completition: { (videoURL, error, localIdentifier) -> () in

            if let err = error {
                print("Error ocurred: \(err)")
            }
            else {
                print("Video url: \(videoURL) with unique id \(localIdentifier)")
            }

        })
    }
    
    @objc func startCapture()
    {
        cameraManager.startRecordingVideo( completion: {(error)->() in
            
            if let err = error {
                print("Error ocurred: \(err)")
            }
            
        })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cameraManager.stopCaptureSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: break
        //handle authorized status
        case .denied, .restricted : break
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized: break
                // as above
                case .denied, .restricted: break
                // as above
                case .notDetermined: break
                    // won't happen but still
                }
            }
        }
    }
    
    
    // MARK: Error Popups
    
    private func addCameraAccessDeniedPopup(message: String) {
        
        DispatchQueue.main.async {
            self.showAlert(title: "TubeAlert", message: message, ok: "Ok", cancel: "", cancelAction: nil, okAction: { alert in
                
                switch UIDevice.current.systemVersion.compare("8.0.0", options: String.CompareOptions.numeric) {
                case .orderedSame, .orderedDescending:
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                case .orderedAscending:
                    print("Not supported")
                    break
               
         
        }
    }, completion: nil)
    }
    
    }
    // MARK: Orientation
    
     func shouldAutorotate() -> Bool {
        return true
    }
    
     func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscapeLeft, UIInterfaceOrientationMask.landscapeRight, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
     func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .portrait
    }
    
    
    // MARK: Add / Revemo camera
    
     func addCameraToView()
    {
        cameraManager.addPreviewLayerToView(view: cameraView, newCameraOutputMode: CameraOutputMode.VideoWithMic)
    }
    
    
    // MARK: @IBActions
    
    @IBAction func changeFlashMode(sender: UIButton)
    {
        switch (cameraManager.changeFlashMode()) {
        case .Off:
            sender.setTitle("Flash Off",  for: .normal)
        case .On:
            sender.setTitle("Flash On",  for: .normal)
        case .Auto:
            sender.setTitle("Flash Auto",  for: .normal)
        }
    }
    
    @IBAction func recordButtonTapped(sender: UIButton) {
        
        switch (cameraManager.cameraOutputMode) {
            
        case .StillImage:
            cameraManager.capturePictureWithCompletition( imageCompletition: { (image, error, localIdentifier) -> () in
                
                if let err = error {
                    print("Error ocurred: \(err)")
                }
                else {
                    print("Image saved to library to id: \(localIdentifier)")
                }
                
            }, name: "ImageName")
            
        case .VideoWithMic, .VideoOnly:
            
            sender.isSelected = !sender.isSelected
            sender.setTitle("", for: .selected)
            sender.backgroundColor = sender.isSelected ? UIColor.red : UIColor.green
            
            if sender.isSelected {
                
                if cameraManager.timer?.state == .TimerStatePaused {
                    
                    cameraManager.resumeRecordingVideo()
                }
                else {
                    
                    cameraManager.startRecordingVideo( completion: {(error)->() in
                        
                        if let err = error {
                            print("Error ocurred: \(err)")
                        }
                        
                    })
                }
            }
            else {
                
                cameraManager.pauseRecordingVideo()
                
                /*
                 cameraManager.stopRecordingVideo( { (videoURL, error, localIdentifier) -> () in
                 
                 if let err = error {
                 print("Error ocurred: \(err)")
                 }
                 else {
                 print("Video url: \(videoURL) with unique id \(localIdentifier)")
                 }
                 
                 })
                 */
            }
        }
    }
    
    @IBAction func outputModeButtonTapped(sender: UIButton) {
        
        cameraButton.isSelected = false
        cameraButton.backgroundColor = UIColor.green
        
        switch (cameraManager.cameraOutputMode) {
        case .VideoOnly:
            cameraManager.cameraOutputMode = CameraOutputMode.StillImage
            sender.setTitle("Photo", for: .normal)//setTitle("", forState: UIControlState.normal)
        case .VideoWithMic:
            cameraManager.cameraOutputMode = CameraOutputMode.VideoOnly
            sender.setTitle("Video", for: .normal)//setTitle("Video", forState: UIControl.State.normal)
        case .StillImage:
            cameraManager.cameraOutputMode = CameraOutputMode.VideoWithMic
            sender.setTitle("Mic On", for: .normal)//setTitle("Mic On", forState: UIControl.State.normal)
        }
    }
    
    @IBAction func changeCameraDevice(sender: UIButton) {
        
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.Front ? CameraDevice.Back : CameraDevice.Front
        switch (cameraManager.cameraDevice) {
        case .Front:
            sender.setTitle("Front", for: .normal)
        case .Back:
            sender.setTitle("Back",for: .normal)
        }
    }
    
    @IBAction func changeCameraQuality(sender: UIButton) {
        
        switch (cameraManager.changeQualityMode()) {
        case .High:
            sender.setTitle("High", for: .normal)
        case .Low:
            sender.setTitle("Low", for: .normal)
        case .Medium:
            sender.setTitle("Medium", for: .normal)
        }
    }
}

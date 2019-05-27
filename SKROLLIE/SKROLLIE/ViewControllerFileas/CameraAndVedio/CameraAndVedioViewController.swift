//
//  CameraAndVedioViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 5/22/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.

import UIKit
import Photos
import AVFoundation
import AVKit
import SRCountdownTimer

protocol CompletedVideoDelegate
{
    func DidComletevideo(FilePath:URL)
}

class CameraAndVedioViewController: SwiftyCamViewController
{
    var VideoRecorderStatus:Int = 0
    var images:[UIImage] = []
    
    var controller = UIImagePickerController()
    
    
    var arrVideoAssets:[AVURLAsset] = []
    
    var isStartVedioOrnot = false
    var secound  = 60
    var timer = Timer()
    var resumTapped = false
    
    var Timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    @IBOutlet weak var Timerlabel: UILabel!
    @IBOutlet weak var ViewCount: SRCountdownTimer!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var PreviewImageView: UIImageView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnPreviewImg: UIButton!
    
    override func viewDidLoad()
    {
        setupUI()
        super.viewDidLoad()
    }
    
    func setupUI() {
        Timerlabel.isHidden = true
        self.TapDelegate = self
        self.cameraDelegate = self
        self.doubleTapCameraSwitch = false
        self.pinchToZoom = true
        self.swipeToZoom = false
        self.swipeToZoomInverted = true
        self.maxZoomScale = 2.0
        self.tapToFocus = false
        self.shouldUseDeviceOrientation = true
        self.audioEnabled = true
        self.allowBackgroundAudio = true
        self.view.bringSubviewToFront(self.PreviewImageView)
        self.btnPreviewImg.isHidden = true
        self.PreviewImageView.isHidden = true
        
        
        btnFlash.setImage(UIImage.init(named: "icon_Flash"), for: .normal)
        btnFlash.setImage(UIImage.init(named: "iconFlashStart"), for: .selected)
        
        //Galary
       
    }
    
    func resetAll() {
        self.stopVideoRecording()
        self.timer.invalidate()
        ViewCount.isHidden = true
        ViewCount.end()
        Timerlabel.isHidden = true
        Timerlabel.text = ""
        isStartVedioOrnot = false
        secound  = 60
        timer = Timer()
        resumTapped = false
    }
    
    // Switch camera front to rear and rear to front
    @IBAction func btnChangeCameraAction(_ sender: Any) {
        self.switchCamera()
    }
    
    // Flash On & OFF Feature
    @IBAction func btnFlashOn(_ sender: UIButton) {
        self.btnFlash.isSelected = !self.btnFlash.isSelected
        if !self.btnFlash.isSelected {
            toggleTorch(on: false)
        } else {
            flashMode.self = .on
            toggleTorch(on: true)
        }
        
    }
    
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func runTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func timeString(time:TimeInterval) -> String
    {
        
        let minutes         = Int(time) / 60
        let seconds         = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        
        return String(format:"%02i.%01i", Int(seconds), Int(secondsFraction * 10.0))
    }
    
    @objc func updateTime()
    {
        if secound == 0 {
            resetAll()
            mergeVideos()
            print("Hellooooooo")
        } else {
            secound -= 1
            Timerlabel.text! = "\(secound)"
            print(Timerlabel.text!)
        }
    }
    
    func ViewCounter()
    {
        ViewCount.labelTextColor = UIColor.white
        if isStartVedioOrnot
        {
            ViewCount.resume()
        }
        else
        {
            ViewCount.start(beginingValue: secound, interval: 1)
        }
        self.ViewCount.timerFinishingText = "0"
        self.ViewCount.labelFont = UIFont.Regular(ofSize: 60)
        self.ViewCount.labelTextColor = UIColor.clear
        self.ViewCount.lineWidth = 5.0
        self.ViewCount.lineColor = UIColor.white
        self.ViewCount.counterLabel.textColor = UIColor.clear
        
    }
    
    
    @IBAction func onBtnPreviewImage(_ sender: Any) {
        
        controller.sourceType = UIImagePickerController.SourceType.photoLibrary
        saveImageDocumentDirectory()
        guard let selectedImage = PreviewImageView.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(imagePhoto(_:didFinishSavingWithError :contextInfo:)), nil)
        
        present(controller, animated: true, completion: nil)
    }
    
    func saveImageDocumentDirectory()
    {
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(".png")
        print(paths)
    }
    
    @objc func imagePhoto(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Photo was saved" : "Photo failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func mergeVideos(){
        print( "Wait... \nVideo is in Process")
        // video Composition Process & Merge Video Process
        let mixComposition = AVMutableComposition.init()
        var timeRange: CMTimeRange!
        var insertTime = CMTime.zero
        
        let track = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                                   preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        for k in 0..<arrVideoAssets.count {
            let videoAsset = arrVideoAssets[k]
            timeRange = CMTimeRangeMake(start: CMTime.zero , duration: videoAsset.duration )
            do {
                
                try track?.insertTimeRange(timeRange, of: videoAsset.tracks(withMediaType: .video)[0], at: insertTime)
                
            } catch let error as NSError {
                
                print("error when adding video to mix = \(error)")
                
            }
            insertTime = CMTimeAdd(insertTime, videoAsset.duration)
            
        }
        dump(mixComposition.tracks)
        
        // Final Video Saved in Document Directory Temporary
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let Filename = "\(Timestamp)_Sample.mp4"
            let fileURL = documentDirectory.appendingPathComponent(Filename)
            let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
            exporter!.outputURL = fileURL
            exporter!.outputFileType = AVFileType.mp4
            exporter!.shouldOptimizeForNetworkUse = false
            exporter!.exportAsynchronously() {
                DispatchQueue.main.async(execute: { () -> Void in
                    // removed all videos
                    self.arrVideoAssets.removeAll()
                    //                   let selectedVideo = fileURL
                    let player = AVPlayer(url: fileURL)  // video path coming from above function
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        print("video saved in Document Directory \nReady to Start Record Next Video...")
                        playerViewController.player!.play()
                        
                    }
                })
            }
        }
        catch {
            print(error)
        }
    }
    
    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                
                print("video saved please check Albums \nReady to Start Record Next Video...")
                
                
                self.clearAllFilesFromTempDirectory()
            })
        }
    }
    
    // Clear Temporary file from Document Directory
    
    func clearAllFilesFromTempDirectory(){
        arrVideoAssets.removeAll()
        var _: NSErrorPointer = nil
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let directoryContents: [String] = try! fileManager.contentsOfDirectory(atPath: documentDirectory.path)
            
            if !directoryContents.isEmpty {
                for path in directoryContents {
                    let fullPath = documentDirectory.appendingPathComponent(path)
                    try fileManager.removeItem(at: fullPath)
                }
            } else {
                //            println("Could not retrieve directory: \(error)")
            }
        } catch {
            print(error)
        }
    }
}

extension CameraAndVedioViewController: SwiftyCamViewControllerDelegate {
    
    // Single Tap on Camera , captured photo can get from this method
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
        self.PreviewImageView.image = photo
        self.PreviewImageView.isHidden = false
        self.btnPreviewImg.isHidden = false
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.PreviewImageView.isHidden = true
        ViewCounter()
        print("Recording...")
        self.btnPreviewImg.isHidden = true
        self.PreviewImageView.isHidden = true
        ViewCount.isHidden = false
        Timerlabel.isHidden = false
        runTimer()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        if self.VideoRecorderStatus == 2 {
            ViewCount.pause()
            isStartVedioOrnot = true
            print("Pause")
            if !resumTapped
            {
                timer.invalidate()
                self.resumTapped = true
            }
        } else if self.VideoRecorderStatus == 0 {
            print("Finishing")
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
        if self.VideoRecorderStatus == 2 {
            print("Pause")
            ViewCount.pause()
            isStartVedioOrnot = true
            if !resumTapped
            {
                runTimer()
                self.resumTapped = false
            }
            else
            {
                timer.invalidate()
                self.resumTapped = true
            }
            let VideoURLAsset = AVURLAsset(url: url)
            self.arrVideoAssets.append(VideoURLAsset)
        }
        else if self.VideoRecorderStatus == 0 {
            print("Finishing")
            let VideoURLAsset = AVURLAsset(url: url)
            self.arrVideoAssets.append(VideoURLAsset)
            resetAll()
            self.mergeVideos()
            
            
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection
    }
}

extension CameraAndVedioViewController: TapGestureDelegate {
    
    // singleTap() and DoubleTap() Both methods of Customer Protocol CompletedVideoDelegate which will get SingleTap Gesture and Double Tap Gesture from SwiftyCamViewController
    func SingleTap()
    {
        
        if VideoRecorderStatus == 0 {
            // Take a Picture on Single tap, while Video recording is not running...
            self.takePhoto()
        }
        else if VideoRecorderStatus == 1 || VideoRecorderStatus == 3
        {
            VideoRecorderStatus = 2
            self.stopVideoRecording()
            
        }
        else if VideoRecorderStatus == 2
        {
            VideoRecorderStatus = 3
            self.startVideoRecording()
            Timerlabel.isHidden = false
        }
    }
    
    func DoubleTap()
    {
        if VideoRecorderStatus == 0
        {
            VideoRecorderStatus = 1
            self.startVideoRecording()
            Timerlabel.isHidden = false
        }
        else
        {
            VideoRecorderStatus = 0
            self.stopVideoRecording()
        }
    }
}

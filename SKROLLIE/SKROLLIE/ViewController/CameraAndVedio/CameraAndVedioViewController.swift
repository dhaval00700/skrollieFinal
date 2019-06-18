//
//  CameraAndVedioViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 5/22/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.

import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import AVKit
import SRCountdownTimer

class CameraAndVedioViewController: SwiftyCamViewController
{
    //MARK: Outlets
    @IBOutlet weak var Timerlabel: UILabel!
    @IBOutlet weak var ViewCount: SRCountdownTimer!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnPreviewImg: UIButton!
    
    //MARK: Properties
    var VideoRecorderStatus:Int = 0
    var images:[UIImage] = []
    
    var controller = UIImagePickerController()
    
    
    var arrVideoAssets:[AVURLAsset] = []
    
    var isStartVedioOrnot = false
    var secound  = 60
    var timer = Timer()
    var resumTapped = false
    
    //MARK: Lifecycles
    override func viewDidLoad()
    {
        setupUI()
        super.viewDidLoad()
    }
    
    
    //MARK: Methods
    func setupUI() {
        fetchPhotos()
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
        self.view.bringSubviewToFront(self.btnPreviewImg)
        
        
        btnFlash.setImage(UIImage.init(named: "icon_Flash"), for: .normal)
        btnFlash.setImage(UIImage.init(named: "iconFlashStart"), for: .selected)
        
        //Galary
       
    }
    
    func resetAll() {
        self.btnPreviewImg.isHidden = false
        VideoRecorderStatus = 0
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
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true  )
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
        loadPhotoGalleryView()
    }
    
    func saveImageDocumentDirectory(image: UIImage) -> URL
    {
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(timestamp)Imag.jpeg")
        if let imageData = UIImage.jpegData(image)(compressionQuality: 0.3) {
            fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
        }
        return URL(fileURLWithPath: path)
    }
    
    @objc func imagePhoto(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Photo was saved" : "Photo failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func orientation(forTrack videoTrack: AVAssetTrack?) -> UIInterfaceOrientation {
        let size: CGSize? = videoTrack?.naturalSize
        let txf: CGAffineTransform? = videoTrack?.preferredTransform
        
        if size?.width == txf?.tx && size?.height == txf?.ty {
            return .landscapeRight
        } else if txf?.tx == 0 && txf?.ty == 0 {
            return .landscapeLeft
        } else if txf?.tx == 0 && txf?.ty == size?.width {
            return .portraitUpsideDown
        } else {
            return .portrait
        }
    }

    
    func mergeVideos() {
        
        print( "Wait... \nVideo is in Process")
        
        let composition = AVMutableComposition()
        
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        var time:Double = 0.0
        
        for k in 0..<arrVideoAssets.count {
            let videoAsset = arrVideoAssets[k]
            let videoAssetTrack = videoAsset.tracks(withMediaType: .video)[0]
            let audioAssetTrack = videoAsset.tracks(withMediaType: .audio)[0]
            let atTime = CMTime(seconds: time, preferredTimescale: 1)
            do {
                videoTrack?.preferredTransform = CGAffineTransform(rotationAngle: .pi/2.0)
                try videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAssetTrack, at: atTime)
                try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: audioAssetTrack, at: atTime)
                
            } catch let error as NSError {
                
                print("error when adding video to mix = \(error)")
                
            }
            time += videoAsset.duration.seconds
        }
        
        dump(composition.tracks)
        
        // Final Video Saved in Document Directory Temporary
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let Filename = "\(timestamp)_Sample.mp4"
            let fileURL = documentDirectory.appendingPathComponent(Filename)
            let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetMediumQuality)
            exporter!.outputURL = fileURL
            exporter!.outputFileType = AVFileType.mp4
            exporter!.shouldOptimizeForNetworkUse = false
            exporter!.exportAsynchronously() {
                DispatchQueue.main.async(execute: { () -> Void in
                    // removed all videos
                    self.arrVideoAssets.removeAll()
                    // let selectedVideo = fileURL
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedVideoViewController") as? SelectedVideoViewController {
                        vc.videoUrl = fileURL
                        /*PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                        }) { saved, error in
                            if saved {
                                print("Saved")
                            }
                        }*/
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                })
                
            }
            
        } catch {
            print(error)
        }
        
    }
    

    
    func mergeVideos1(){
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
            let Filename = "\(timestamp)_Sample.mp4"
            let fileURL = documentDirectory.appendingPathComponent(Filename)
            let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
            exporter!.outputURL = fileURL
            exporter!.outputFileType = AVFileType.mp4
            exporter!.shouldOptimizeForNetworkUse = false
            exporter!.exportAsynchronously() {
                DispatchQueue.main.async(execute: { () -> Void in
                    // removed all videos
                    self.arrVideoAssets.removeAll()
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedVideoViewController") as? SelectedVideoViewController {
                        vc.videoUrl = fileURL
                        /*PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                        }) { saved, error in
                            if saved {
                                print("Saved")
                            }
                        }*/
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                })
            }
        }
        catch {
            print(error)
        }
    }
}

extension CameraAndVedioViewController: SwiftyCamViewControllerDelegate {
    
    // Single Tap on Camera , captured photo can get from this method
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
        self.btnPreviewImg.setBackgroundImage(photo, for: .normal)
        /*PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: self.saveImageDocumentDirectory(image: photo))//creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { saved, error in
            if saved {
                print("Saved")
            }
        }*/
        self.btnPreviewImg.isHidden = false
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedImageViewController") as? SelectedImageViewController {
            vc.selectedImage = photo
            vc.selectedImageUrl = saveImageDocumentDirectory(image: photo)
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        ViewCounter()
        print("Recording...")
        self.btnPreviewImg.isHidden = true
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
        if camera == .front {
            disableFlash()
        }
        // Called when user switches between cameras
        // Returns current camera selection
    }
}

extension CameraAndVedioViewController: TapGestureDelegate {
    
   // singleTap() and DoubleTap() Both methods of Customer Protocol CompletedVideoDelegate which will get SingleTap Gesture and Double Tap Gesture from SwiftyCamViewController
   func SingleTap() {
        
        if VideoRecorderStatus == 0 {
            // Take a Picture on Single tap, while Video recording is not running...
            self.perform(#selector(takephotofromSingleTAP), with: nil, afterDelay: 0.5)
            //            self.takePhoto()
        } else if VideoRecorderStatus == 1 || VideoRecorderStatus == 3 {
            VideoRecorderStatus = 2
            self.stopVideoRecording()
            
        } else if VideoRecorderStatus == 2 {
            VideoRecorderStatus = 3
            self.startVideoRecording()
            self.Timerlabel.isHidden = false
        }
    }
    
    @objc func takephotofromSingleTAP() {
        if VideoRecorderStatus == 0 {
            self.takePhoto()
        }
    }
    
    func DoubleTap() {
        if VideoRecorderStatus == 0 {
            VideoRecorderStatus = 1
            self.startVideoRecording()
            Timerlabel.isHidden = false
        } else {
            VideoRecorderStatus = 0
            resetAll()
        }
    }
}

//MARK: - UIImagePickerControllerDelegate and Take a Photo or Choose from Gallery Methods
extension CameraAndVedioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedImageViewController") as? SelectedImageViewController {
                vc.selectedImage = editedImage
                vc.selectedImageUrl = saveImageDocumentDirectory(image: editedImage)
                navigationController?.pushViewController(vc, animated: false)
            }
            print("image")
        } else{
            
            if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                if let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedVideoViewController") as? SelectedVideoViewController {
                    vc.videoUrl = videoUrl
                    navigationController?.pushViewController(vc, animated: false)
                }
            }
            print("Video")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func loadPhotoGalleryView()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            if imagePickerController.mediaTypes == [kUTTypeImage as String] {
                imagePickerController.allowsEditing = false
            } else {
                imagePickerController.allowsEditing = true
                imagePickerController.videoMaximumDuration = 60
                imagePickerController.videoQuality = .typeHigh
            }
            
            imagePickerController.delegate = self
            
            
            present(imagePickerController, animated: true, completion: nil)
        }
        else
        {
            print("Photo library does not avaialable on this device.")
        }
    }
    
}


extension CameraAndVedioViewController {
    func fetchPhotos() {
        // Sort the images by descending creation date and fetch the first 3
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 3
        
        // Fetch the image assets
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        // If the fetch result isn't empty,
        // proceed with the image request
        if fetchResult.count > 0 {
            let totalImageCountNeeded = 1 // <-- The number of images to fetch
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }
    
    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        // Perform the image request
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
            if let image = image {
                // Add the returned image to your array
                self.images += [image]
            }
            
            if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            } else {
                // Else you have completed creating your array
                print("Completed array: \(self.images)")
                
                if self.images.count > 0{
                    //self.PreviewImageView.image = self.images.first!
                    self.btnPreviewImg.setBackgroundImage(self.images.first!, for: .normal)
                }
            }
        })
    }
}

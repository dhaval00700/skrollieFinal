//  vedioTimerDemoVC.swift
//  SKROLLIE
//  Created by Dhaval Bhanderi on 4/26/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.

import UIKit
import SRCountdownTimer
import MobileCoreServices
import AVFoundation
import Photos
import AssetsLibrary

class CameraVc: UIViewController,AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate
{
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var ViewSaveVedio: UIView!
    @IBOutlet weak var camPreview: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Variabel Declaration
    //-------------------------------------------------------------
    
    let cameraButton = UIView()
    var controller = UIImagePickerController()
    let movieOutput = AVCaptureMovieFileOutput()
    let videoOutput = AVCaptureVideoDataOutput()
    var outputURL: URL!
    var isCamera = false
    var isVedio = false
    
    var currentCameraPosition: CameraPosition?
    var captureSession: AVCaptureSession?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.off
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?

    //-------------------------------------------------------------
    // MARK: - View Methos
    //-------------------------------------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupSession()
        //Vedio
        AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        let vedio = UITapGestureRecognizer(target: self, action: #selector(TappedForPhotos))
        vedio.numberOfTapsRequired = 1
        if vedio.numberOfTapsRequired == 1
        {
            isVedio = true
        }
        camPreview.addGestureRecognizer(vedio)
        
        //Photo
        
        let Photo = UITapGestureRecognizer(target: self, action: #selector(CameraVc.startCapture))
        Photo.numberOfTapsRequired = 2
        if Photo.numberOfTapsRequired == 2
        {
            
        }
        camPreview.addGestureRecognizer(Photo)
        
        vedio.require(toFail: Photo)
        prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.displayPreview(on: self.camPreview)
        }
    }
    
    //MARK:- Setup Camera
    
    func setupSession() -> Bool {
        
        captureSession?.sessionPreset = AVCaptureSession.Preset.high
        
        // Setup Camera
        let camera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: camera!)
            if captureSession?.canAddInput(input) ?? false
            {
                captureSession?.addInput(input)
                rearCameraInput = input
            }
        }
        catch
        {
            print("Error setting device video input: \(error)")
            return false
        }
        
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)
        
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone!)
            if captureSession?.canAddInput(micInput) ?? false {
                captureSession?.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
        
        // Movie output
        if (captureSession?.canAddOutput(movieOutput)) ?? false {
            captureSession?.addOutput(movieOutput)
        }
        
        return true
    }

    @objc func TappedForPhotos()
    {
//           saveImageDocumentDirectory()
        if(isCamera){
              print("singal tap..VideoRecord")
            isCamera = false;
//               videoOutput.stopRecording()
         
        }else{
            print("singal tap..dont press me too hard")
        captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
//            guard let selectedImage = captureImageView.image else {
//                print("Image not found!")
//                return
//            }
//            UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError :contextInfo:)), nil)
            
//
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self )
        self.photoCaptureCompletionBlock = completion
        
//        performSegue(withIdentifier: "showVideo", sender: self)
        
    }
    
    @objc func startCapture()
    {
        print("double tap i m fine")
        isCamera = true
        startRecording()
        //        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        //        stillImageOutput.capturePhoto(with: settings, delegate: self)
        
    }
    func startRecording() {
        if(isCamera)
        {
//            captureSession?.removeInput(rearCameraInput!)
//
//
//            prepare2 {(error) in
//                if let error = error {
//                    print(error)
//                }
//
//                try? self.displayPreview(on: self.camPreview)
//            }
//            isCamera = false;
        }
        if movieOutput.isRecording == false {
            
//            print("start")
//
//
//            let connection = movieOutput.connection(with: AVMediaType.video)
//
//            if (connection?.isVideoOrientationSupported)! {
//                connection?.videoOrientation = currentVideoOrientation()
//            }
//
//            if (connection?.isVideoStabilizationSupported)! {
//                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
//            }
//
//            let device = rearCameraInput!.device
//            if (device.isSmoothAutoFocusSupported) {
//                do {
//                    try device.lockForConfiguration()
//                    device.isSmoothAutoFocusEnabled = false
//                    device.unlockForConfiguration()
//                } catch {
//                    print("Error setting configuration: \(error)")
//                }
//
//            }
//
//            //EDIT2: And I forgot this
//            outputURL = tempURL()
//            print(outputURL)
//            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
        }
        else {
            stopRecording()
        }
        
    }
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        return orientation
    }
    
    func stopRecording() {
        print("stop")
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
        }
    }
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    
    func saveImageDocumentDirectory()
    {
        
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(".png")
        
        let image = UIImage(named: ".png")
        
        print(paths)
        
    }
   
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
           if (isCamera) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        print(isCamera)
        CVPixelBufferLockBaseAddress(pixelBuffer,
                                     CVPixelBufferLockFlags.readOnly)
        
       // displayEqualizedPixelBuffer(pixelBuffer: pixelBuffer)
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer,
                                       CVPixelBufferLockFlags.readOnly)
        }
    }
//    if(videoWriterInput.readyForMoreMediaData && isRecording) [videoWriterInput appendSampleBuffer:sampleBuffer];
    
   
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("perfomr");
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {
            
            let videoRecorded = outputURL! as URL
            
            performSegue(withIdentifier: "showVideo", sender: videoRecorded)
        }
    }
    
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! VideoPlayback
        vc.videoURL = sender as! URL
        
    }
    
    
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(previewLayer!, at: 0)
        previewLayer?.frame = view.frame
    }

    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            var session : AVCaptureDevice.DiscoverySession!
            if UI_USER_INTERFACE_IDIOM() == .phone {
                let screenSize: CGSize = UIScreen.main.bounds.size
                if screenSize.height == 812 {
                    session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
                } else {
                    session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
                }
            }
            
            let cameras = session.devices.compactMap { $0 }
            guard !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
                
                self.currentCameraPosition = .rear
            }
                
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
                
                self.currentCameraPosition = .front
            }
                
           
                
            else { throw CameraControllerError.noCamerasAvailable }
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            let dataOutputQueue = DispatchQueue(label: "video data queue",
                                                qos: .userInitiated,
                                                attributes: [],
                                                autoreleaseFrequency: .workItem)
            
            videoOutput.setSampleBufferDelegate(self ,
                                                queue: dataOutputQueue)
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)

            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
            
            
            
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func prepare2(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            let cameras = session.devices.compactMap { $0 }
            guard !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
                
                self.currentCameraPosition = .rear
            }
                
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
                
                self.currentCameraPosition = .front
            }
            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
            }
                
            else { throw CameraControllerError.noCamerasAvailable }
        }
        
  
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
              
                
             
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
}

class VideoPlayback: UIViewController {
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var videoURL: URL!
    
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = view.bounds
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.layer.insertSublayer(avPlayerLayer, at: 0)
        
        view.layoutIfNeeded()
        
        let playerItem = AVPlayerItem(url: videoURL as URL)
        avPlayer.replaceCurrentItem(with: playerItem)
        
        avPlayer.play()
    }
}


extension CameraVc: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                            resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)
        }
            
        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}
extension CameraVc {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}
//
//class PhotoVc: UIViewController {
//     var imgUrl : URL!
//     let imgView = UIImageView()
//    @IBOutlet weak var imgPhoto: UIImageView!
//
//    override func viewDidLoad() {
//        self.viewDidLoad()
//
//        imgUrl = UIImageView.init(image: )
//    }
//}

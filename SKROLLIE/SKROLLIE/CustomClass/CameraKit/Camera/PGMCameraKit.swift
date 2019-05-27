/*
Copyright (c) 2015 Pablo GM <invanzert@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

import UIKit
import AVFoundation
import AssetsLibrary
import Photos


// MARK: Typedef

public typealias VideoCompletionType = (NSURL?, NSError?, LocalIdentifierType?) -> ()
public typealias CompletionType      = () -> ()
public typealias CompletionBoolType  = (Bool) -> ()
public typealias CompletionErrorType = (NSError?) -> ()
public typealias SizeCompletionType  = (Int64?) -> ()
public typealias TimeCompletionType  = (String?) -> ()
public typealias ImageCompletionType = (UIImage?, NSError?, LocalIdentifierType?) -> ()

@objc public class PGMCameraKit: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    
    // MARK: Public properties
    
    /// Capture session to customize camera settings.
    public var captureSession: AVCaptureSession?
    
    /// Bool property to determine if current device has front camera.
    public var hasFrontCamera: Bool = {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for  device in devices  {
            let captureDevice = device as! AVCaptureDevice
            if (captureDevice.position == .front) {
                return false
            }
        }
        
        return false
    }()
    
    /// Bool property to determine if current device has flash.
    public var hasFlash: Bool = {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for  device in devices  {
            let captureDevice = device as! AVCaptureDevice
            if (captureDevice.position == .back) {
                return captureDevice.hasFlash
            }
        }
        return false
    }()
    
    /// Property to change camera device between front and back.
    public var cameraDevice = CameraDevice.Front {
        didSet {
            if cameraDevice != oldValue {
                updateCameraDevice(deviceType: cameraDevice)
                
            }
        }
    }
    
    /// Property to change camera flash mode.
    public var flashMode = CameraFlashMode.Off {
        didSet {
            if flashMode != oldValue {
                updateFlasMode(flashMode: flashMode)
            }
        }
    }
    
    /// Property to change camera output quality.
    public var cameraOutputQuality = CameraOutputQuality.High {
        didSet {
            if cameraOutputQuality != oldValue {
                updateCameraQualityMode(newCameraOutputQuality: cameraOutputQuality)
            }
        }
    }
    
    /// Property to change camera output.
    public var cameraOutputMode = CameraOutputMode.VideoWithMic {
        didSet {
            if cameraOutputMode != oldValue {
                setupOutputMode(newCameraOutputMode: cameraOutputMode, oldCameraOutputMode: oldValue)
            }
        }
    }
    
    /// This property specifies a hard limit on the duration of recorded files.
    public var maxRecordedDuration:TimeInterval = 9.0
    
    /// Video preview layer
    public var previewLayer: AVCaptureVideoPreviewLayer?
    
    /// Timer to handle video state (paused, recording, ...)
    public var timer:PGMTimer?
    
    
    // MARK: Internal properties
    
    /// Still image output
    internal var stillImageOutput: AVCaptureStillImageOutput?
    
    /// Movie output
    internal var movieOutput: AVCaptureVideoDataOutput?
    
    /// Audio output
    internal var audioOutput: AVCaptureAudioDataOutput?
    
    /// View where to place the preview layer
    internal weak var embedingView: UIView?
    
    
    // MARK: Private properties
    
    private var videoCompletition: VideoCompletionType?
    
    private let lockQueue       = DispatchQueue(label: "com.aumentia.lockQueue")
    
    private let sessionQueue    = DispatchQueue(label: "com.aumentia.recordingQueue")
    
    private lazy var frontCameraDevice: AVCaptureDevice? = {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video) as! [AVCaptureDevice]
        return devices.filter{$0.position == .front}.first
    }()
    
    private lazy var backCameraDevice: AVCaptureDevice? = {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video) as! [AVCaptureDevice]
        return devices.filter{$0.position == .back}.first
    }()
    
    private lazy var mic: AVCaptureDevice? = {
        return AVCaptureDevice.default(for: AVMediaType.audio)
    }()
    
    private var library: PHPhotoLibrary?
    
    private var videoWriter : PGMCameraKitWriter?
    
    private let cameraKitErrorDomain = "cameraKitErrorDomain"
    
    private var height:Int?
    private var width:Int?
    
    private var cameraIsSetup   = false
    private var isCapturing     = false
    private var isPaused        = false
    private var isDiscontinue   = false
    private var isInitialSetup  = true
    
    private var fileIndex       = 0
    
    private var timeOffset      = CMTimeMake(value: 0, timescale: 0)
    private var lastAudioPts: CMTime?
    
    private var cameraError: CompletionErrorType?
    private var cameraMaxAllowedLength: VideoCompletionType?
    private var cameraTime: TimeCompletionType?
    
    
    // MARK: Paths
    
    /**
    Temporal path where the original video is stored
    
    - returns: Original video path
    */
    public func tempFilePath() -> URL {
        
        return FileManagerass.getPath(name: "tempMovie", ext: "mp4")
    }
    
    /**
     Temporal path where the compressed video is stored
     
     - parameter ext: Compressed video extension
     
     - returns: Compressed video path
     */
    public func tempCompressFilePath(ext: String) -> URL {
        
        return FileManagerass.getPath(name: "tempCompressMovie", ext: ext)
    }
    
    
    // MARK: Listeners
    
    /**
    Use this listener to track errors
    
    - parameter cameraError: CompletionErrorType
    */
    public func addCameraErrorListener(cameraError: @escaping CompletionErrorType) {
        self.cameraError = cameraError
    }
    
    /**
     Use this listener to track the time progress
     
     - parameter cameraTime: TimeCompletionType
     */
    public func addCameraTimeListener(cameraTime: @escaping TimeCompletionType) {
        self.cameraTime = cameraTime
    }
    
    /**
     Use this listener to be notified when reached the max allowed video time lenght
     
     - parameter cameraMaxAllowedLength: VideoCompletionType
     */
    public func addMaxAllowedLengthListener(cameraMaxAllowedLength: @escaping VideoCompletionType) {
        self.cameraMaxAllowedLength = cameraMaxAllowedLength
    }
    
    
    // MARK: CameraManager
    
    /**
    Inits a capture session and adds a preview layer to the given view.
    Preview layer bounds will automaticaly be set to match given view.
    Default session is initialized with still image output.
    
    - parameter view:                The view you want to add the preview layer to
    - parameter newCameraOutputMode: The mode you want capturesession to run image / video / video and microphone
    
    - returns: Current state of the camera: Ready / AccessDenied / NoDeviceFound / NotDetermined.
    */
    public func addPreviewLayerToView(view: UIView, newCameraOutputMode: CameraOutputMode) -> CameraState {
        
        if canLoadCamera() {
            
            if let _ = embedingView {
                
                if let validPreviewLayer = previewLayer {
                    validPreviewLayer.removeFromSuperlayer()
                }
            }
            
            if cameraIsSetup {
                
                addPreeviewLayerToView(view: view)
                cameraOutputMode = newCameraOutputMode
            }
            else {
                setupCamera(completition: { [weak self] () -> () in
                    self?.addPreeviewLayerToView(view: view)
                    self?.cameraOutputMode = newCameraOutputMode
                })
            }
        }
        
        return checkIfCameraIsAvailable()
    }
    
    /**
     Asks the user for camera permissions.
     Only works if the permissions are not yet determined.
     Note that it'll also automaticaly ask about the microphone permissions if you selected VideoWithMic output.
     
     - parameter completition: Completition block with the result of permission request
     */
    public func askUserForCameraPermissions(completition: @escaping CompletionBoolType) {
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self] (alowedAccess) -> () in
            
            if self?.cameraOutputMode == .VideoWithMic {
                
                AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (alowedAccess) -> () in
                    
                    DispatchQueue.main.async{ () -> () in
                        completition(alowedAccess)
                    }
                })
            }
            
            else {
                
                DispatchQueue.main.async{ () -> () in
                    completition(alowedAccess)
                }
            }
            })
    }
    
    /**
     Stops running capture session but all setup devices, inputs and outputs stay for further reuse.
     */
    public func stopCaptureSession() {
        captureSession?.stopRunning()
        stopFollowingDeviceOrientation()
    }
    
    /**
     Resumes capture session.
     */
    public func resumeCaptureSession() {
        
        if let validCaptureSession = captureSession {
            
            if !validCaptureSession.isRunning && cameraIsSetup {
                
                validCaptureSession.startRunning()
                startFollowingDeviceOrientation()
            }
        }
        else {
            
            if canLoadCamera() {
                
                if cameraIsSetup {
                    stopAndRemoveCaptureSession()
                }
                setupCamera(completition: { [weak self] () -> () in
                    
                    if let validEmbedingView = self?.embedingView {
                        
                        
                        self?.addPreeviewLayerToView(view: validEmbedingView)
                        
                    }
                    self?.startFollowingDeviceOrientation()
                    })
            }
        }
    }
    
    /**
     Get video data output
     
     - returns: AVCaptureVideoDataOutput
     */
    public func getMovieOutput() -> AVCaptureVideoDataOutput {
        
        var shouldReinitializeMovieOutput = movieOutput == nil
        
        if !shouldReinitializeMovieOutput {
            if let connection = movieOutput!.connection(with: AVMediaType.video) {
                shouldReinitializeMovieOutput = shouldReinitializeMovieOutput || !connection.isActive
            }
        }
        
        if shouldReinitializeMovieOutput {
            
            setupMovieOutput()
        }
        
        return movieOutput!
    }
    
    
    // MARK: Still Image
    
    /**
    Captures still image from currently running capture session.
    
    - parameter imageCompletition: imageCompletition Completition block containing the captured UIImage
    */
    public func capturePictureWithCompletition(imageCompletition: @escaping ImageCompletionType, name: String) {
        
        if cameraIsSetup {
            
            if cameraOutputMode == .StillImage {
                
               DispatchQueue(label: "sessionQueue").async {
                    
                    self.getStillImageOutput().captureStillImageAsynchronously(from: self.getStillImageOutput().connection(with: AVMediaType.video)!, completionHandler: { (sample: CMSampleBuffer!, error: NSError!) -> () in
                        
                        if (error != nil) {
                            imageCompletition(nil, error, "")
                        }
                        else {
                            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sample)
                            
                            // Get a reference to our helper
                            let helper = PGMCameraKitHelper()
                            
                            // Save the image to library
                            if let imageToSave = UIImage(data: imageData!) {
                                
                                helper.saveImageAsAsset(image: imageToSave, completion: { (localIdentifier, error) -> () in
                                    
                                    imageCompletition(imageToSave, error as Error? as NSError?, localIdentifier)
                                })
                            }
                            else {
                                imageCompletition(UIImage(data: imageData!), nil, "")
                            }
                        }
                        } as! (CMSampleBuffer?, Error?) -> Void as! (CMSampleBuffer?, Error?) -> Void)
                }
            }
            else {
                
                let err = NSError(localizedDescription: "Can not take the picture", localizedFailureReason: "Capture session output mode video", domain: cameraKitErrorDomain)
                imageCompletition(nil, err, "")
            }
        }
        else {
            
            let err = NSError(localizedDescription: "Can not take the picture", localizedFailureReason: "No capture session setup", domain: cameraKitErrorDomain)
            imageCompletition(nil, err, "")
        }
    }
    
    
    // MARK: Video: start, stop, pause, resume
    
    /**
    Start recording video
    
    - parameter completion: CompletionErrorType
    */
    public func startRecordingVideo(completion: CompletionErrorType) {
        
        if cameraOutputMode != .StillImage {
            
            self.lockQueue.sync() {
                
                if !self.isCapturing{
                    
                    print("Start recording")
                    
                    self.isPaused       = false
                    self.isDiscontinue  = false
                    self.isCapturing    = true
                    self.timeOffset     = CMTimeMake(value: 0, timescale: 0)
                    
                    guard self.timer == nil else {
                        fatalError("Timer should be nil")
                    }
                    
                    self.timer = PGMTimer(timerEnd: self.maxRecordedDuration, timerWillStart: {}, timerDidFire: { [weak self] time in
                        
                        self?.cameraTime?(time)
                        
                        }, timerDidPause: {
                            
                            print("Pause recording")
                            
                        }, timerWillResume: {
                            
                            print("Resume recording")
                            
                        }, timerDidStop: { [weak self] in
                            
                            self?.stopProcess(reachedMaxAllowedLenght: false)
                            
                        }, timerDidEnd: { [weak self] time in
                            
                            self?.stopProcess(reachedMaxAllowedLenght: true)
                        })
                    
                    self.timer?.start()
                    
                    self.captureSession?.beginConfiguration()
                    if self.flashMode != .Off {
                        self.updateTorch(flashMode: self.flashMode)
                    }
                    self.captureSession?.commitConfiguration()
                    
                    completion(nil)
                }
            }
        }
        else {
            let err = NSError(localizedDescription: "Can not record video", localizedFailureReason: "Can only take pictures", domain: cameraKitErrorDomain)
            completion(err)
        }
    }
    
    /**
     Stop recording video
     
     - parameter completition: VideoCompletionType
     */
    public func stopRecordingVideo(completition:@escaping VideoCompletionType) {
        
        if let _ = movieOutput {
            
            self.lockQueue.sync() {
                
                guard (self.timer?.state == .TimerStateRunning) else {
                    
                    print("Can not stop")
                    return
                }
                
                if self.isCapturing {
                    
                    print("Stop recording")
                    
                    self.videoCompletition = completition
                    
                    guard self.timer != nil else {
                        fatalError("Timer should not be nil")
                    }
                    
                    self.timer?.stop()
                }
            }
        }
    }
    
    /**
     Pause recording video
     */
    public func pauseRecordingVideo() {
        
        self.lockQueue.sync() {
            
            if self.isCapturing {
                
                guard (self.timer?.state == .TimerStateRunning) else {
                    
                    print("Can not pause")
                    return
                }
                
                self.isPaused = true
                self.isDiscontinue = true
                self.timer?.pause()
            }
        }
    }
    
    /**
     Resume recording video
     */
    public func resumeRecordingVideo() {
        
        self.lockQueue.sync() {
            
            if self.isCapturing{
                
                guard (self.timer?.state == .TimerStatePaused) else {
                    
                    print("Can not resume")
                    return
                }
                
                self.isPaused = false
                self.timer?.resume()
            }
        }
    }
    
    
    // MARK: Camera properties
    
    /**
    Current camera status.
    
    - returns: Current state of the camera: Ready / AccessDenied / NoDeviceFound / NotDetermined
    */
    public func currentCameraStatus() -> CameraState {
        return checkIfCameraIsAvailable()
    }
    
    /**
     Change current flash mode to next value from available ones.
     
     - returns: Current flash mode: Off / On / Auto
     */
    public func changeFlashMode() -> CameraFlashMode {
        flashMode = CameraFlashMode(rawValue: (flashMode.rawValue + 1) % 3)!
        return flashMode
    }
    
    /**
     Change current output quality mode to next value from available ones.
     
     - returns: Current quality mode: Low / Medium / High
     */
    public func changeQualityMode() -> CameraOutputQuality {
        cameraOutputQuality = CameraOutputQuality(rawValue: (cameraOutputQuality.rawValue + 1) % 3)!
        return cameraOutputQuality
    }
    
    
    // MARK: AVCaptureDataVideoDelegate
    
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        self.lockQueue.sync() {
            
            if !self.isCapturing || self.isPaused {
                return
            }
            
            var isVideo = captureOutput is AVCaptureVideoDataOutput
            isVideo = true
            if self.cameraOutputMode == .VideoWithMic {
                
                if self.videoWriter == nil && !isVideo {
                    
                    if self.videoWriter == nil && !isVideo {
                        
                        let fileManager = FileManager()
                        
                        if fileManager.fileExists(atPath: self.filePath()) {
                            do {
                                try fileManager.removeItem(atPath: self.filePath())
                            }
                            catch let outError as NSError {
                                
                                let err = NSError(localizedDescription: "Error removing file: \(outError.localizedDescription)",
                                    localizedFailureReason: outError.localizedFailureReason,
                                    domain: self.cameraKitErrorDomain)
                                
                                self.cameraError?(err)
                            }
                        }
                        
                        let fmt = CMSampleBufferGetFormatDescription(sampleBuffer)
                        let asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt!)
                        
                        print("setup video writer (with mic)")
                        
                        var w:Int!
                        var h:Int!
                        
                        if self.isInitialSetup == true {
                            
                            self.isInitialSetup = false
                            
                            if AVCaptureVideoOrientation(ui:UIDevice.current.orientation) == .portrait {
                                w = self.height
                                h = self.width
                            }
                            else {
                                w = self.width
                                h = self.height
                            }
                        }
                        else {
                            w = self.width
                            h = self.height
                        }
//
                        self.videoWriter = PGMCameraKitWriter(
                            fileUrl: self.filePathUrl() as URL,
                            height: self.height!,
                            width: self.width!
                        )
                    }
                }
            }
            else {
                if self.videoWriter == nil && isVideo {
                    
                    let fileManager = FileManager()
                    
                    if fileManager.fileExists(atPath: self.filePath()) {
                        do {
                            try fileManager.removeItem(atPath: self.filePath())
                        }
                        catch let outError as NSError {
                            
                            let err = NSError(localizedDescription: "Error removing file: \(outError.localizedDescription)",
                                localizedFailureReason: outError.localizedFailureReason,
                                domain: self.cameraKitErrorDomain)
                            
                            self.cameraError?(err)
                        }
                    }
                    
                    print("setup video writer (only video)")
                    
                    self.videoWriter = PGMCameraKitWriter(
                        fileUrl: self.filePathUrl() as URL,
                        height: self.height!,
                        width: self.width!
                    )
                }
            }
            
            
            if self.isDiscontinue {
                if isVideo {
                    return
                }
                
                var pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                
                let isAudioPtsValid = self.lastAudioPts!.flags.intersection(CMTimeFlags.valid)
                
                if isAudioPtsValid.rawValue != 0 {
                    
                    print("isAudioPtsValid is valid")
                    
                    let isTimeOffsetPtsValid = self.timeOffset.flags.intersection(CMTimeFlags.valid)
                    
                    if isTimeOffsetPtsValid.rawValue != 0 {
                        print("isTimeOffsetPtsValid is valid")
                        pts = CMTimeSubtract(pts, self.timeOffset);
                    }
                    let offset = CMTimeSubtract(pts, self.lastAudioPts!);
                    
                    if (self.timeOffset.value == 0)
                    {
                        print("timeOffset is \(self.timeOffset.value)")
                        self.timeOffset = offset;
                    }
                    else
                    {
                        print("timeOffset is \(self.timeOffset.value)")
                        self.timeOffset = CMTimeAdd(self.timeOffset, offset);
                    }
                }
                self.lastAudioPts!.flags = CMTimeFlags()
                self.isDiscontinue = false
            }
            
            var buffer = sampleBuffer
            if self.timeOffset.value > 0 {
                buffer = self.ajustTimeStamp(sample: sampleBuffer, offset: self.timeOffset)
            }
            
            if !isVideo {
                var pts = CMSampleBufferGetPresentationTimeStamp(buffer!)
                let dur = CMSampleBufferGetDuration(buffer!)
                if (dur.value > 0)
                {
                    pts = CMTimeAdd(pts, dur)
                }
                self.lastAudioPts = pts
            }
            
            self.videoWriter?.write(sample: buffer!, isVideo: isVideo)
        }
    }
    
//     MARK: Private Functions
    
    // MARK: Setups

    private func ajustTimeStamp(sample: CMSampleBuffer, offset: CMTime) -> CMSampleBuffer {

        var count: CMItemCount = 0
        CMSampleBufferGetSampleTimingInfoArray(sample, entryCount: 0, arrayToFill: nil, entriesNeededOut: &count)

//        var info = [CMSampleTimingInfo](_unsafeUninitializedCapacity: count, initializingWith: CMSampleTimingInfo(duration: CMTime(value: 20, timescale: 20), presentationTimeStamp: CMTime(value: 20, timescale: 20), decodeTimeStamp: CMTime(value: 20, timescale: 20)))
        
       // CMSampleBufferGetSampleTimingInfoArray(sample, count, &info, &count);

//        for i in 0..<count {
//            info[i].decodeTimeStamp = CMTimeSubtract(info[i].decodeTimeStamp, offset);
//            info[i].presentationTimeStamp = CMTimeSubtract(info[i].presentationTimeStamp, offset);
//        }
//
//
        var sbufWithNewTiming: CMSampleBuffer? = nil
//
//        let err = CMSampleBufferCreateCopyWithNewTiming(kCFAllocatorDefault,
//                                                        sample,
//                                                        count,
//                                                        &info,
//                                                        &sbufWithNewTiming)
//        if err != 0 {
//            print("Error \(err)")
//        }

        return sbufWithNewTiming!
    }
    private func updateTorch(flashMode: CameraFlashMode) {
        
        captureSession?.beginConfiguration()
        
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        
        for  device in devices  {
            
            let captureDevice = device as! AVCaptureDevice
            
            if (captureDevice.position == AVCaptureDevice.Position.back) {
                
                let avTorchMode = AVCaptureDevice.TorchMode(rawValue: flashMode.rawValue)
                
                if (captureDevice.isTorchModeSupported(avTorchMode!)) {
                    
                    do {
                        try captureDevice.lockForConfiguration()
                    }
                    catch {
                        return;
                    }
                    captureDevice.torchMode = avTorchMode!
                    captureDevice.unlockForConfiguration()
                }
            }
        }
        captureSession?.commitConfiguration()
    }
    
    private func setupMovieOutput() -> AVCaptureVideoDataOutput? {
        
        movieOutput = AVCaptureVideoDataOutput()
        
        if let videoDataOutput = movieOutput {
            
            videoDataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            let setcapSettings: [NSObject : AnyObject] = [
                kCVPixelBufferPixelFormatTypeKey : Int(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange) as AnyObject
            ]
            videoDataOutput.videoSettings = setcapSettings as! [String : Any]
            
        }
        
        return movieOutput
    }
    
    private func setupAudioOutput() -> AVCaptureAudioDataOutput? {
        
        audioOutput = AVCaptureAudioDataOutput()
        
        if let audioDataOutput = audioOutput {
            
            audioDataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        }
        
        return audioOutput
    }
    
    private func getStillImageOutput() -> AVCaptureStillImageOutput {
        
        var shouldReinitializeStillImageOutput = stillImageOutput == nil
        
        if !shouldReinitializeStillImageOutput {
            
            if let connection = stillImageOutput!.connection(with: AVMediaType.video) {
                shouldReinitializeStillImageOutput = shouldReinitializeStillImageOutput || !connection.isActive
            }
        }
        
        if shouldReinitializeStillImageOutput {
            
            stillImageOutput = AVCaptureStillImageOutput()
            
            captureSession?.beginConfiguration()
            captureSession?.addOutput(stillImageOutput!)
            captureSession?.commitConfiguration()
        }
        
        return stillImageOutput!
    }
    private func setupCamera(completition: @escaping CompletionType) {
        captureSession = AVCaptureSession()
        
      DispatchQueue(label: "sessionQueue").async {
            if let validCaptureSession = self.captureSession {
                validCaptureSession.beginConfiguration()
                validCaptureSession.sessionPreset = AVCaptureSession.Preset.high
                self.updateCameraDevice(deviceType: self.cameraDevice)
                self.setupOutputs()
                self.setupOutputMode(newCameraOutputMode: self.cameraOutputMode, oldCameraOutputMode: nil)
                self.setupPreviewLayer()
                validCaptureSession.commitConfiguration()
                self.updateFlasMode(flashMode: self.flashMode)
                self.updateCameraQualityMode(newCameraOutputQuality: self.cameraOutputQuality)
                validCaptureSession.startRunning()
                self.startFollowingDeviceOrientation()
                self.cameraIsSetup = true
                self.isInitialSetup = true
                self.orientationChanged()
                
                completition()
            }
        }
    }
    
    private func setupOutputMode(newCameraOutputMode: CameraOutputMode, oldCameraOutputMode: CameraOutputMode?) {
        
        captureSession?.beginConfiguration()
        
        if let cameraOutputToRemove = oldCameraOutputMode {
            
            // remove current setting
            switch cameraOutputToRemove {
                
            case .StillImage:
                if let validStillImageOutput = stillImageOutput {
                    captureSession?.removeOutput(validStillImageOutput)
                }
                
            case .VideoOnly, .VideoWithMic:
                if let validVideoOutput = movieOutput {
                    captureSession?.removeOutput(validVideoOutput)
                }
                if let validAudioOutput = audioOutput {
                    captureSession?.removeOutput(validAudioOutput)
                }
                if cameraOutputToRemove == .VideoWithMic {
                    removeMicInput()
                }
            }
        }
        
        // Configure new devices
        switch newCameraOutputMode {
            
        case .StillImage:
            if (stillImageOutput == nil) {
                setupOutputs()
            }
            if let validStillImageOutput = stillImageOutput {
                captureSession?.addOutput(validStillImageOutput)
            }
        case .VideoOnly, .VideoWithMic:
            let videoDataOutput = getMovieOutput()
            captureSession?.addOutput(videoDataOutput)
            height = videoDataOutput.videoSettings["Height"] as! Int?
            width = videoDataOutput.videoSettings["Width"] as! Int?
            
            if newCameraOutputMode == .VideoWithMic {
                if let validMic = deviceInputFromDevice(device: mic) {
                    captureSession?.addInput(validMic)
                    captureSession?.addOutput(setupAudioOutput()!)
                }
            }
        }
        captureSession?.commitConfiguration()
        updateCameraQualityMode(newCameraOutputQuality: cameraOutputQuality)
        orientationChanged()
    }
    
    private func setupOutputs() {
        
        if (stillImageOutput == nil) {
            stillImageOutput = AVCaptureStillImageOutput()
        }
        if (movieOutput == nil) {
            movieOutput = setupMovieOutput()
        }
        if (audioOutput == nil) {
            audioOutput = setupAudioOutput()
        }
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    if self.library == nil {
                        self.library = PHPhotoLibrary()
                    }
                }
            })
        } else {
            //saveVideoToPhotos()
        }
      
  
    }
    
    private func setupPreviewLayer() {
        if let validCaptureSession = captureSession {
            previewLayer = AVCaptureVideoPreviewLayer(session: validCaptureSession)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
    }
    
    // MARK: Update State
    
    private func updateCameraDevice(deviceType: CameraDevice) {
        
        if let validCaptureSession = captureSession {
            validCaptureSession.beginConfiguration()
            let inputs = validCaptureSession.inputs as! [AVCaptureInput]
            
            for input in inputs {
                if let deviceInput = input as? AVCaptureDeviceInput {
                    if deviceInput.device == backCameraDevice && cameraDevice == .Front {
                        validCaptureSession.removeInput(deviceInput)
                        break;
                    } else if deviceInput.device == frontCameraDevice && cameraDevice == .Back {
                        validCaptureSession.removeInput(deviceInput)
                        break;
                    }
                }
            }
            switch cameraDevice {
                
            case .Front:
                
                if hasFrontCamera {
                    
                    if let validFrontDevice = deviceInputFromDevice(device: frontCameraDevice) {
                        
                        frontCameraDevice!.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 30)
                        
                        if !inputs.contains(validFrontDevice) {
                            validCaptureSession.addInput(validFrontDevice)
                        }
                    }
                }
            case .Back:
                
                if let validBackDevice = deviceInputFromDevice(device: backCameraDevice) {
                    
                    backCameraDevice!.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 30)
                    
                    if !inputs.contains(validBackDevice) {
                        validCaptureSession.addInput(validBackDevice)
                    }
                }
            }
            
            isInitialSetup = false
            
            validCaptureSession.commitConfiguration()
        }
    }
    
    private func updateFlasMode(flashMode: CameraFlashMode) {
        
        captureSession?.beginConfiguration()
        
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        
        for  device in devices  {
            
            let captureDevice = device as! AVCaptureDevice
            
            if (captureDevice.position == AVCaptureDevice.Position.back) {
                
                let avFlashMode = AVCaptureDevice.FlashMode(rawValue: flashMode.rawValue)
                
                if (captureDevice.isFlashModeSupported(avFlashMode!)) {
                    
                    do {
                        try captureDevice.lockForConfiguration()
                    }
                    catch {
                        return
                    }
                    captureDevice.flashMode = avFlashMode!
                    captureDevice.unlockForConfiguration()
                }
            }
        }
        captureSession?.commitConfiguration()
    }
    
    private func updateCameraQualityMode(newCameraOutputQuality: CameraOutputQuality) {
        
        if let validCaptureSession = captureSession {
            
            var sessionPreset = AVCaptureSession.Preset.low
            
            switch (newCameraOutputQuality) {
                
            case CameraOutputQuality.Low:
                sessionPreset = AVCaptureSession.Preset.low
            case CameraOutputQuality.Medium:
                sessionPreset = AVCaptureSession.Preset.medium
            case CameraOutputQuality.High:
                if cameraOutputMode == .StillImage {
                    sessionPreset = AVCaptureSession.Preset.photo
                }
                else {
                    sessionPreset = AVCaptureSession.Preset.high
                }
            }
            
            if validCaptureSession.canSetSessionPreset(sessionPreset) {
                validCaptureSession.beginConfiguration()
                validCaptureSession.sessionPreset = sessionPreset
                validCaptureSession.commitConfiguration()
            }
            else {
                
                let err = NSError(localizedDescription: "Preset not supported",
                    localizedFailureReason: "Camera preset not supported. Please try another one.",
                    code: CameraError.CameraPresetNotSupported.rawValue,
                    domain: cameraKitErrorDomain)
                
                cameraError?(err)
            }
        }
        else {
            
            let err = NSError(localizedDescription: "Camera error. ",
                localizedFailureReason: "No valid capture session found, I can't take any pictures or videos.",
                code: CameraError.NoValidCaptureSession.rawValue,
                domain: cameraKitErrorDomain)
            
            cameraError?(err)
        }
    }
    
    private func stopProcess(reachedMaxAllowedLenght:Bool) {
        
        let url = self.filePathUrl()
        
        self.fileIndex += 1
        
        self.isCapturing = false
        
       DispatchQueue(label: "sessionQueue").async {() -> Void in
            
            self.videoWriter!.finish(callback: {() -> Void in
                
                self.isCapturing = false
                self.videoWriter = nil
                self.timer       = nil
                
                self.updateTorch(flashMode: .Off)
                
                // Get a reference to our helper
                let helper = PGMCameraKitHelper()
                
                // Save the image to library
                helper.saveVideoAsAsset(videoURL: url as! URL, completion: { (localIdentifier, error) -> () in
                    
                    print("save completed")
                    
                    if reachedMaxAllowedLenght == false {
                        // Manual stop
                        self.executeVideoCompletitionWithURL(url: url, error: error as NSError?, localIdentifier: localIdentifier)
                    }
                    else {
                        // Automatic stop: remove manually the link
                        self.cameraMaxAllowedLength?(url, error as NSError?, localIdentifier)
                    }
                    
                })
            })
        }
    }
    
    private func addPreeviewLayerToView(view: UIView) {
        embedingView = view
        DispatchQueue.main.async {
            () -> () in
            guard let _ = self.previewLayer else {
                return
            }
            self.previewLayer!.frame = view.layer.bounds
            view.clipsToBounds = true
            view.layer.addSublayer(self.previewLayer!)
        }
    }
    
    // MARK: Completion callbaks
    
    private func executeVideoCompletitionWithURL(url: NSURL?, error: NSError?, localIdentifier: LocalIdentifierType?) {
        
        if let validCompletition = videoCompletition {
            
            validCompletition(url, error, localIdentifier)
            videoCompletition = nil
        }
    }
    
    // MARK: Clean up
    
    /**
    Stops running capture session and removes all setup devices, inputs and outputs.
    */
    private func stopAndRemoveCaptureSession() {
        
        stopCaptureSession()
        cameraDevice        = .Back
        cameraIsSetup       = false
        previewLayer        = nil
        captureSession      = nil
        frontCameraDevice   = nil
        backCameraDevice    = nil
        mic                 = nil
        stillImageOutput    = nil
        movieOutput         = nil
        audioOutput         = nil
        library             = nil
        timer               = nil
    }
    
    private func removeMicInput() {
        
        guard let inputs = captureSession?.inputs as? [AVCaptureInput] else { return }
        
        for input in inputs {
            
            if let deviceInput = input as? AVCaptureDeviceInput {
                
                if deviceInput.device == mic {
                    captureSession?.removeInput(deviceInput)
                    break;
                }
            }
        }
    }
    
    // MARK: Helper Functions
    
    private func filePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/video\(self.fileIndex).mp4"
        let _ = NSURL(fileURLWithPath: filePath)
        return filePath
    }
    
    private func filePathUrl() -> NSURL! {
        return NSURL(fileURLWithPath: self.filePath())
    }
    
    private func deviceInputFromDevice(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        
        guard let validDevice = device else {
            return nil
        }
        
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        }
        catch let outError as NSError {
            
            let err = NSError(localizedDescription: "Device setup error occured: \(outError.localizedDescription)",
                localizedFailureReason: outError.localizedFailureReason,
                code: CameraError.DeviceSetupError.rawValue,
                domain: cameraKitErrorDomain)
            
            cameraError?(err)
            
            return nil
        }
        catch {
            return nil
        }
    }
    
    private func canLoadCamera() -> Bool {
        let currentCameraState = checkIfCameraIsAvailable()
        return currentCameraState == .Ready || (currentCameraState == .NotDetermined)
    }
    
    private func checkIfCameraIsAvailable() -> CameraState {
        
        
        let deviceHasCamera = UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) || UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front)
        
        if deviceHasCamera {
            
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            let userAgreedToUseIt = authorizationStatus == .authorized
            
            if userAgreedToUseIt {
                return .Ready
            }
            else if authorizationStatus == AVAuthorizationStatus.notDetermined {
                return .NotDetermined
            }
            else {
                
                let err = NSError(localizedDescription: "Camera access denied",
                    localizedFailureReason: "Go to settings and grant acces to the camera device to use it.",
                    code: CameraError.CameraAccessDeniend.rawValue,
                    domain: cameraKitErrorDomain)
                
                cameraError?(err)
                
                return .AccessDenied
            }
        }
        else {
            
            let err = NSError(localizedDescription: "Camera unavailable",
                localizedFailureReason: "The device does not have a camera.",
                code: CameraError.CameraUnavailable.rawValue,
                domain: cameraKitErrorDomain)
            
            cameraError?(err)
            
            return .NoDeviceFound
        }
    }
    
    
    // MARK: deinit
    
    deinit {
        stopAndRemoveCaptureSession()
        stopFollowingDeviceOrientation()
    }

}

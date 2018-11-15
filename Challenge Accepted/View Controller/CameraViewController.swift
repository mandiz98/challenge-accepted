//
//  CameraViewController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-11-12.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSess()
        
    }
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo //photo in full resolution
    }
    
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
                
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput(){
        do{
            if currentCamera == nil {print("fel")}
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!) /* error because no camera on computer simulator. always nil */
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        }catch {
            print(error)
        }
        
        
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSess(){
        captureSession.startRunning()
    }
    

    @IBAction func CameraButton(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        // performSegue(withIdentifier: "PhotoSegue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoSegue"{
            let previewVC = segue.destination as! PrevieveViewController
            previewVC.image = self.image
        }
    }
    
}

extension ViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            print(imageData)
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "PhotoSegue", sender: nil)
        }
        
    }


}

//
//  cameraController.swift
//  Challenge Accepted
//
//  Created by Amanda Axelsson on 2018-11-26.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//
/*
import UIKit
import AVFoundation //The api we use are available in the AVFoundation framework

class CameraController {
    
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvaliable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],mediaType: AVMediaType.video, position: .unspecified)
            guard let cameras = (session.devices.compactMap {$0}), !cameras.isEmpty else { throw CameraControllerError.noCamerasAvaliable }
            
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
            guard (self.captureSession != nil) else {throw CameraControllerError.captureSessionIsMissing}
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if (captureSession?.canAddInput(self.rearCameraInput!))!{
                    captureSession?.addInput(self.rearCameraInput!)
                }
                self.currentCameraPosition = .rear
            }
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if (captureSession?.canAddInput(self.frontCameraInput!))! {
                    captureSession?.addInput(self.frontCameraInput!)
                }
                else { throw CameraControllerError.inputsAreInvalid }
                
                self.currentCameraPosition = .front
            }
            else { throw CameraControllerError.noCamerasAvaliable }
        }
        
        
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing}
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput!) {captureSession.addOutput(self.photoOutput!) }
            
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do{
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
            catch{
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
    
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing}
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }

}
*/

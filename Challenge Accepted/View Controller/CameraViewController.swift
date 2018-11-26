//
//  CameraViewController.swift
//  Challenge Accepted
//
//  Created by Dennis Molund on 2018-11-13.
//  Copyright © 2018 Amanda Axelsson. All rights reserved.
//

import UIKit
import AVFoundation //The api we use are available in the AVFoundation framework

class CameraViewController: UIViewController {
    
    
    /*
    let cameraController = CameraController()
    
    override func viewDidLoad() {
        func configureCameraController(){
            cameraController.prepare {(error) in
                if let error = error{
                    print(error)
                }
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }
        
        configureCameraController()
    }*/
        
    
    ///DENNIS CAMERA
    
    var tapGesture = UITapGestureRecognizer()
    //Koden som är "bortkommenterad" funkar troligen på mobilkamera.
    
    var captureSession = AVCaptureSession() //instnace of AVcaptureSession
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer? //Display video as its being capture by an input device, the layer is then added to the views layer to display on the screen.
    var image: UIImage?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCaptureSession() //Creating Capture session
        setupDevice() //Configuring the nessesary capture devices
        setupInputOutput() // Creating Inputs using the capture devices
        setupPreviewLayer() //Configureing a photo output object to prosess capture images
        startRunningCaptureSess() //Capture session will start running when we have finnished the configuration
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        performSegue(withIdentifier: "photoSegue", sender: nil) //sender is the object we want to use to initiate the segue
    }
    
    @objc func doubleTapped() {
        if currentCamera == backCamera{
            print("front")
            currentCamera = frontCamera
            
        }
        else {
            print("back")
            currentCamera = backCamera
            
        }
    }
    
    
     
     //CODE DO NOT WORK IN SIMULATOR SINCE THERE IS NO CAMERA
     
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        //specify the imagequality and resulation we want, preset the session for taking photos in full resolution
        
    }
    
    
    //show captures on screen.
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession) //Creating instance of AVCaptureVid... using CaptureSess.. as the paramiter
        
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill //how is the videopreview is displayed? AspectFill!
        
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait //set it's layers to have the portrate oriantation
        
        
        //update the frame for this layer to give a fullscreen camera interface. we just assign viewsframe to it and add the previewlayer to the view layer at index 0 to unhide the button
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSess(){
        //start capturing data
        captureSession.startRunning()
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
        if currentCamera == nil{
            currentCamera = frontCamera
        }
     }
    
    func setupInputOutput(){
     do{
         if currentCamera == nil {print("fel")}
             let captureDeviceInput = try AVCaptureDeviceInput(device: /* error because no camera on computer simulator. always nil */ currentCamera!)
             captureSession.addInput(captureDeviceInput)
             photoOutput = AVCapturePhotoOutput()
             photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
             captureSession.addOutput(photoOutput!)
     }catch {
        print(error)
     }
     
     }
    /*
    func switchCamera(){
        switch currentPosition{
            case .unspecified, .back:
                preferredPosition = .front
                preferredDeviceType = .builtInDualCamera
            
            case .front:
                preferredPosition = .back
                preferredDeviceType = .builtInTrueDepthCamera
            }
        }
*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSegue"{
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "photoSegue", sender: nil)
        }
        
    }
}




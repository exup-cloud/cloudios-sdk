//
//  EXImagePicker.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/16.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import PhotosUI
import MobileCoreServices

@objc protocol EXImagePickerDelegate: class {

    @objc optional func selectImageFinished(_ image:UIImage)
}

typealias cameraSuccess   = (_ imagePickerController:UIImagePickerController)  -> Void


class EXImagePicker: NSObject {
    private var imagePickerController:UIImagePickerController!
    private var image:UIImage?
    weak var delegate:EXImagePickerDelegate?

    
    deinit{
        print("dealloc : \(self)")
    }
    
    override init() {
        super.init()
        prepareCamera()
    }
    
    func prepareCamera() {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
    }
    
    //MARK:从相机拍摄图片
    func selectImageFromCameraSuccess(_ closure:@escaping cameraSuccess,Fail failClosure:(() -> Void)? = nil){
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .restricted || authStatus == .denied{
            if failClosure != nil {
                failClosure!()
                DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 0.4) {
                    EXAlert.showFail(msg: "common_tip_cameraPermission".localized())
                }
            }
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = [kUTTypeImage as String]
//            imagePickerController.cameraCaptureMode = .photo
            closure(imagePickerController)
        }
    }
    
    //MARK:从相机拍摄图片
    func selectImageFromAlbumSuccess(_ closure:@escaping cameraSuccess,Fail failClosure:(() -> Void)? = nil){
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .restricted || authStatus == .denied{
            if failClosure != nil {
                DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 0.4) {
                    EXAlert.showFail(msg: "common_tip_cameraPermission".localized())
                }
                failClosure!()
            }
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePickerController.sourceType = .savedPhotosAlbum
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            closure(imagePickerController)
        }
    }
    
}

extension EXImagePicker : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType:String = info[UIImagePickerControllerMediaType] as! String
        if mediaType == kUTTypeImage as String{
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.delegate?.selectImageFinished?(image!)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EXImagePicker : UINavigationControllerDelegate {
    
}

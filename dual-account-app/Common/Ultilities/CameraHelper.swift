//
//  CameraHelper.swift
//  MeeTruckMouseDrivers
//
//  Created by user.name on 20/01/2021.
//

import MobileCoreServices
import UIKit

final class CameraHelper: NSObject {
    
    private var imagePicker = UIImagePickerController()
    private let isPhotoLibraryAvailable = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    private let isSavedPhotoAlbumAvailable = UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
    private let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
    private let isRearCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.rear)
    private let isFrontCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front)
    private let sourceTypeCamera = UIImagePickerController.SourceType.camera
    private let rearCamera = UIImagePickerController.CameraDevice.rear
    private let frontCamera = UIImagePickerController.CameraDevice.front
    
    weak var delegate: (UINavigationControllerDelegate & UIImagePickerControllerDelegate)?
    
    init(`delegate`: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        self.delegate = `delegate`
    }
    
    func getPhotoLibraryOn(_ onVC: UIViewController, canEdit: Bool) {
        imagePicker = UIImagePickerController()
        guard isPhotoLibraryAvailable && isSavedPhotoAlbumAvailable else { return }
        let type = kUTTypeImage as String
        
        if isPhotoLibraryAvailable {
            imagePicker.sourceType = .photoLibrary
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if availableTypes.contains(type) {
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
        } else if isSavedPhotoAlbumAvailable {
            imagePicker.sourceType = .savedPhotosAlbum
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if availableTypes.contains(type) {
                    imagePicker.mediaTypes = [type, "public.movie"]
                }
            }
        } else {
            return
        }
        imagePicker.navigationBar.tintColor = .blue
        imagePicker.navigationBar.barStyle = .default
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = delegate
        onVC.present(imagePicker, animated: true, completion: nil)
    }
    
    func getCameraOn(_ onVC: UIViewController, canEdit: Bool) {
        DispatchQueue.main.async {
            self.imagePicker = UIImagePickerController()
            guard self.isCameraAvailable else { return }
            let type1 = kUTTypeImage as String
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                if availableTypes.contains(type1) {
                    self.imagePicker.mediaTypes = [type1]
                    self.imagePicker.sourceType = self.sourceTypeCamera
                }
            }
            
            if self.isRearCameraAvailable {
                self.imagePicker.cameraDevice = self.rearCamera
            } else if self.isFrontCameraAvailable {
                self.imagePicker.cameraDevice = self.frontCamera
            }
            
            self.imagePicker.allowsEditing = canEdit
            self.imagePicker.showsCameraControls = true
            self.imagePicker.delegate = self.delegate
            onVC.present(self.imagePicker, animated: true, completion: nil)
        }
    }
}

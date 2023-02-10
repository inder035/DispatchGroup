//
//  ImagePicker.swift
//  Offerpad Connect
//
//  Created by Inderjeet Singh on 19/01/23.
//

import UIKit
import Photos
import Foundation

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var alert = UIAlertController(title: "Choose a Source", message: nil, preferredStyle: .actionSheet)
    private var picker = UIImagePickerController()
    private var viewController: UIViewController?
    private var pickImageCallback : ((UIImage) -> ())?
    
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        self.pickImageCallback = callback
        self.viewController = viewController
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ UIAlertAction in self.openCamera() }
        let gallaryAction = UIAlertAction(title: "Photo Library", style: .default){ UIAlertAction in self.openGallery() }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        self.picker.delegate = self
        self.alert.addAction(cameraAction)
        self.alert.addAction(gallaryAction)
        self.alert.addAction(cancelAction)
        self.alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        self.alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            self.picker.sourceType = .camera
            self.picker.allowsEditing = true
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            debugPrint("You don't have camera")
        }
    }
   
    func openGallery(){
        self.alert.dismiss(animated: true, completion: nil)
        self.picker.sourceType = .photoLibrary
        self.picker.allowsEditing = true
        self.picker.modalPresentationStyle = .fullScreen
        self.viewController!.present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as? UIImage
        self.pickImageCallback?(image!)
    }
}

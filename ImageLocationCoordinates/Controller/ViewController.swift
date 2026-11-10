//
//  ViewController.swift
//  ImageLocationCoordinates
//
//  Created by Devika on 08/11/2026.
//

import UIKit
import Photos
import AssetsLibrary

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var latLongLabel: UILabel!
    
    let imagePicker: UIImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    @IBAction func galleryButtonAction(_ sender: UIButton) {
        self.latLongLabel.text = ""
        PresentAlertViewController()
    }
    
    func PresentAlertViewController() {
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { [weak self](_) in
                guard let self = self else { return }
                // Present the UIImagePickerController
                DispatchQueue.main.async {
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.imagePicker.allowsEditing = false
                    let alert = UIAlertController(title: "Upload Photo", message: "Select source for uploading photo", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Camera", style: .default
                        , handler: { (camera) in
                            self.imagePicker.sourceType = .camera
                            self.present(self.imagePicker, animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (photoLib) in
                        self.imagePicker.sourceType = .photoLibrary
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let coordinate = (info[UIImagePickerController.InfoKey.phAsset] as? PHAsset)?.location?.coordinate
        self.latLongLabel.text = "\(coordinate?.latitude ?? 0.0), \(coordinate?.longitude ?? 0.0)"
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

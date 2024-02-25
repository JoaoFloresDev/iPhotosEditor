//
//  PresentPhotoVC.swift
//  Photo Collage Maker
//
//  Created by Grapes Infosoft on 14/09/19.
//  Copyright © 2019 Grapes Infosoft. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos

class PresentPhotoVC: UIViewController,OpalImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    var objIndex = 0
    var objTotalImgSelection = 0
    var picker = OpalImagePickerController()
    var objSelectiontype = 0
    var imagePicker = UIImagePickerController()

    //MARK:- Outlets
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        picker.imagePickerDelegate = self
        picker.delegate = self
        btnDismiss.backgroundColor = UIColor.clear
        btnDismiss.alpha = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK:- Button Action Zone
    
    @IBAction func btnDismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCameraAction(_ sender: UIButton) {
        openCamera()
    }
    @IBAction func btnGalleryAction(_ sender: UIButton) {
        openGallery()
    }
    
    //MARK:- UIImagePicker Delegate Methods
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        if objSelectiontype == 1{
            picker.delegate = self
            if self.objTotalImgSelection == 1{
                picker.maximumSelectionsAllowed = 1
            }else if self.objTotalImgSelection == 2{
                picker.maximumSelectionsAllowed = 2
            }else if self.objTotalImgSelection == 3{
                picker.maximumSelectionsAllowed = 3
            }else if self.objTotalImgSelection == 4{
                picker.maximumSelectionsAllowed = 4
            }else if self.objTotalImgSelection == 5{
                picker.maximumSelectionsAllowed = 5
            }
            picker.imagePickerDelegate = self
            presentOpalImagePickerController(picker, animated: true, select: { (asset) in
                let requestOptions = PHImageRequestOptions()
                requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
                requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
                requestOptions.isSynchronous = true
                var thumbnail = [UIImage]()

                self.picker.dismiss(animated: true, completion: nil)
                for images in asset{
//                    if (images.mediaType == PHAssetMediaType.image){
                        PHImageManager.default().requestImage(for: images , targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (pickedImage, info) in
                            thumbnail.append(pickedImage!)
                        })
//                    }
                }
                let obj = self.storyboard!.instantiateViewController(withIdentifier: "EditImageVC") as! EditImageVC
                obj.objIndex = self.objIndex
                obj.objPickImage = 0
                obj.objpresentPhotoVC = self
                obj.objType = 1
                obj.arrOfTotalImg.append(contentsOf: thumbnail)
                self.navigationController?.pushViewController(obj, animated: true)
            }, cancel: {
            })
        }else if objSelectiontype == 2{
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let obj : EditImageVC = self.storyboard?.instantiateViewController(withIdentifier: "EditImageVC") as! EditImageVC
            obj.imgValue = pickedImage
            obj.objpresentPhotoVC = self
            obj.objType = 2
            self.navigationController?.pushViewController(obj, animated: true)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

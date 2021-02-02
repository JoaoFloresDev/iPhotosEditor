//
//  ViewController.swift
//  CollageMaker
//
//  Created by iMac on 13/09/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class HomeVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //MARK:- outlets
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    //MARK:- Button Action Zone
    @IBAction func btnGridAction(_ sender: Any) {
        openGallary()
    }
    
    @IBAction func btnEditAction(_ sender: Any) {
    }
    
    //MARK:- UIImagePicker Delegate Methods
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let obj :LoadShapesVC  = self.storyboard?.instantiateViewController(withIdentifier: "LoadShapesVC") as! LoadShapesVC
            obj.pickImg = pickedImage
            self.navigationController?.pushViewController(obj, animated: true)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


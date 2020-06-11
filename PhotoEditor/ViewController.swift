//
//  ViewController.swift
//  CLImageEditor-Swift
//
//  Created by dirtbag on 3/16/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit
import CLImageEditor
import Agrume

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate,  CLImageEditorDelegate {
    
    //    MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellOptions: UIView!
    
    @IBOutlet weak var backgroundCellImage: UIImageView!
    @IBOutlet weak var cellImage: UIView!
    @IBOutlet weak var backgroundOptions: UIImageView!
    //    MARK: - IBAction
    @IBAction func showImg(_ sender: Any) {
        let agrume = Agrume(image: imageView.image!)
          agrume.show(from: self)
        }
    
    @IBAction func editImgTest(_ sender: Any) {
        newImage()
    }
    
    @IBAction func saveImgTest(_ sender: Any) {
        saveImage()
    }
    
    @IBAction func editeeeImgTest(_ sender: Any) {
        editImage()
    }
    
    //    MARK: - VARIABLES
    let STORED_IMAGE_NAME = "/stored_image_name.png"
    
    //    MARK: - LIFE CYCLE
    /// load any stored image
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image = readImageFromStorage()
        if image == nil {
            image = UIImage(named: "placeholder")
        }
        imageView.image = image
        
        cellOptions.clipsToBounds = false
        cellOptions.layer.shadowColor = UIColor.black.cgColor
        cellOptions.layer.shadowOpacity = 0.5
        cellOptions.layer.shadowRadius = 3
        cellOptions.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundOptions.layer.cornerRadius = 10
        
        cellImage.clipsToBounds = false
        cellImage.layer.shadowColor = UIColor.black.cgColor
        cellImage.layer.shadowOpacity = 0.5
        cellImage.layer.shadowRadius = 3
        cellImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundCellImage.layer.cornerRadius = 10
    }
    
    /// called when an image has been chosen
    /// here we start the editor with the new image
    
    //    MARK: - imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        imageView.image = image
        imageView.layer.cornerRadius = 10
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// called when editor completes
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        
        imageView.image = image
        editor.dismiss(animated: true, completion: nil)
    }
    
    //    MARK: - tabBar
    // mark - Tab Bar Delegate
    @objc func deselectTabBarItem(tabBar: UITabBar) {
        
        tabBar.selectedItem = nil
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        self.perform(#selector(deselectTabBarItem(tabBar:)), with: tabBar, afterDelay: 0.2)
        
        switch (item.tag) {
        case 0:
            self.newImage()
            break
            
        case 1:
            self.editImage()
            break
            
        case 2:
            self.saveImage()
            break
            
        default:
            break
        }
    }
    
    
    /// mark - Tab bar actions
    
    /// get a new image to edit
    func newImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //    MARK: - OPTIONS
    /// edit current image
    func editImage() {
        
        if (imageView.image != nil) {
            let editor = CLImageEditor(image: imageView.image, delegate: self)
            self.present(editor!, animated: true, completion: nil)
            
        } else {
            newImage()
        }
    }
    
    /// save current image
    func saveImage() {
        if let image = imageView.image {
            showShareSheet(image: image)
        }
    }
    
    func showShareSheet(image: UIImage) {
        
        let shareViewController: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = self.view
        shareViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        shareViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(shareViewController, animated: true)
    }
    
    //    MARK: - IMAGE MAGEMENT
    func readImageFromStorage() -> UIImage? {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if documentsPath.count > 0 {
            let documentDirectory = documentsPath[0]
            let restorePath = documentDirectory + STORED_IMAGE_NAME
            
            let image = UIImage(contentsOfFile: restorePath)
            
            return image
        } else {
            return nil
        }
    }
    
    func writeImageToStorage(image: UIImage) -> Bool {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        return true
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

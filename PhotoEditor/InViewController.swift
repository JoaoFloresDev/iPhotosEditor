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
import StoreKit
import GoogleMobileAds

class InViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate,  CLImageEditorDelegate, GADInterstitialDelegate {
    
    //    MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellOptions: UIView!
    @IBOutlet weak var backgroundCellImage: UIImageView!
    @IBOutlet weak var cellImage: UIView!
    @IBOutlet weak var backgroundOptions: UIImageView!
    
    //    MARK: - IBAction
    @IBAction func showImg(_ sender: Any) {
        guard let image = imageView.image else {
            editImage()
            return
        }
        let agrume = Agrume(image: image)
        agrume.show(from: self)
    }
    
    @IBAction func editImgTest(_ sender: Any) {
        newImage()
    }
    
    @IBAction func saveImgTest(_ sender: Any) {
        if(RazeFaceProducts.store.isProductPurchased("NoAds.iPhotos") || (UserDefaults.standard.object(forKey: "NoAds.iPhotos") != nil)) {
            saveImage()
        }
        else if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        else {
            saveImage()
        }
    }
    
    @IBAction func editeeeImgTest(_ sender: Any) {
        editImage()
    }
    
    //    MARK: - VARIABLES
    let STORED_IMAGE_NAME = "/stored_image_name.png"
    
    var interstitial: GADInterstitial!
    
    //    MARK: - LIFE CYCLE
    /// load any stored image
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/6846096563")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        print("-------------")
        print("interstitialDidDismissScreen")
        self.saveImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        ADS
        interstitial = createAndLoadInterstitial()
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/6846096563")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
        let image = readImageFromStorage()
        if image != nil {
            imageView.image = image
            backgroundCellImage.image = nil
        }
        
        cellOptions.clipsToBounds = false
        cellOptions.layer.shadowColor = UIColor.gray.cgColor
        cellOptions.layer.shadowOpacity = 0.5
        cellOptions.layer.shadowRadius = 3
        cellOptions.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundOptions.layer.cornerRadius = 10
        
        cellImage.clipsToBounds = false
        cellImage.layer.shadowColor = UIColor.gray.cgColor
        cellImage.layer.shadowOpacity = 0.7
        cellImage.layer.shadowRadius = 5
        cellImage.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCellImage.layer.cornerRadius = 10

        view.backgroundColor = .black
        backgroundCellImage.backgroundColor = .black
        backgroundOptions.backgroundColor = .black
        newImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if let backButtonImage = UIImage(named: "back")?.resize(targetSize: CGSize(width: 30, height: 30)) {
            // Crie um botão personalizado com a imagem
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(botaoEsquerdoClicado))
            backButton.tintColor =  .white
            // Defina o botão personalizado como o botão de volta da barra de navegação
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc func botaoEsquerdoClicado() {
        navigationController?.popToRootViewController(animated: true)
    }

    func saveTodayDate() {
        let now = Date()
        UserDefaults.standard.set(now, forKey: "LastSavedDate")
    }

    func check30DaysPassed() -> Bool {
        if let lastSavedDate = UserDefaults.standard.object(forKey: "LastSavedDate") as? Date {
            let dayDifference = Calendar.current.dateComponents([.day], from: lastSavedDate, to: Date()).day ?? 0
            
            return dayDifference >= 7
        }
        saveTodayDate()
        return false
    }
    
    //    MARK: - imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        imageView.image = image
        backgroundCellImage.image = nil
        imageView.layer.cornerRadius = 10
        picker.dismiss(animated: true)
        self.editImage()
    }
    
    /// called when editor completes
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        
        imageView.image = image
        backgroundCellImage.image = nil
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
            editor?.view.backgroundColor = .black
            editor?.modalPresentationStyle = .fullScreen
            self.present(editor!, animated: true, completion: nil)
        } else {
            newImage()
        }
    }
    
    /// save current image
    func saveImage() {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
        else {
            showAlertWith(title: "Error", message: "Try again.")
        }
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
    
    //    ADS LIFECYCLE
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("-------------")
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("-------------")
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("-------------")
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("-------------")
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("-------------")
        print("interstitialWillLeaveApplication")
    }
}

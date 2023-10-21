//
//  ShareVC.swift
//  Photo Collage Maker
//
//  Created by Grapes Infosoft on 14/09/19.
//  Copyright © 2019 Grapes Infosoft. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ShareVC: UIViewController, GADInterstitialDelegate {

    var getImage = UIImage()
    var arrAddImage = NSMutableArray()
    var objDisplay = 0
    var index = 0
    var objSetDelete = MyAlbumVC()
    var interstitial: GADInterstitial!
    
    //MARK:- Outlets
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgDisplay: UIImageView!
    @IBOutlet weak var viewButtons: UIView!

    @IBOutlet weak var viewSave: UIView!
    @IBOutlet weak var viewDelete: UIView!

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

        if objDisplay == 1{
            imgDisplay.image = getImage
            btnShare.isHidden = false
            viewSave.isHidden = false
            viewDelete.isHidden = true
        }else if objDisplay == 2{
            imgDisplay.image = getImage
            btnShare.isHidden = false
            viewSave.isHidden = true
            viewDelete.isHidden = false
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnShareAction(_ sender: UIButton) {
        let imageToShare = [ getImage ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
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
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        showDeleteWarning(index)
    }
    
    @IBAction func btnHomeAction(_ sender: UIButton) {
        if objDisplay == 1{
            self.navigationController?.popViewController(animated: true)
        }else if objDisplay == 2{
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    func showDeleteWarning(_ index : Int) {
        let alert = UIAlertController(title: "Delete", message: "Did you want to Delete this Photo?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.objSetDelete.objDelete = 1
                let temp = ((userDefault.object(forKey: "img")as AnyObject) as! NSArray)
                self.arrAddImage = temp.mutableCopy() as! NSMutableArray
                self.arrAddImage.removeObject(at: self.index)
                userDefault.set(self.arrAddImage, forKey: "img")
                userDefault.synchronize()
                self.navigationController?.popViewController(animated: true)
                self.objSetDelete.arrOfAlbumList = (userDefault.object(forKey: "img") as! NSArray)
                self.objSetDelete.AlbumsCV.reloadData()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(getImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

        UIImageWriteToSavedPhotosAlbum(getImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}

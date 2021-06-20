//
//  ViewController.swift
//  Photo Collage Maker
//
//  Created by Grapes Infosoft on 14/09/19.
//  Copyright © 2019 Grapes Infosoft. All rights reserved.
//

import UIKit
import StoreKit

class HomeVC: UIViewController, SKStoreProductViewControllerDelegate{

    //MARK:- outlets
    @IBOutlet weak var btnMyAlbums: UIButton!
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var marketingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        marketingButton.layer.borderWidth = 2
        marketingButton.layer.borderColor = UIColor.white.cgColor
        marketingButton.layer.cornerRadius = 4
    }

    //MARK:- Button Action Zone
    @IBAction func marketingButtonImage(_ sender: Any) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1502280869") {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func btnGridAction(_ sender: Any) {
        let obj : LoadShapesVC = self.storyboard?.instantiateViewController(withIdentifier: "LoadShapesVC") as! LoadShapesVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
  
    @IBAction func btnEditAction(_ sender: Any) {
        let obj = self.storyboard!.instantiateViewController(withIdentifier: "PresentPhotoVC") as! PresentPhotoVC
        obj.objSelectiontype = 2
        let navController = UINavigationController(rootViewController: obj)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .overCurrentContext
        self.present(navController, animated:true, completion: nil)
    }
    @IBAction func btnMyAlbumsAction(_ sender: Any) {
        let obj : MyAlbumVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAlbumVC") as! MyAlbumVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
}


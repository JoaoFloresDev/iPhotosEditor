//
//  ViewController.swift
//  Photo Collage Maker
//
//  Created by Grapes Infosoft on 14/09/19.
//  Copyright © 2019 Grapes Infosoft. All rights reserved.
//

import UIKit

class HomeVC: UIViewController{

    //MARK:- outlets
    @IBOutlet weak var btnMyAlbums: UIButton!
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:- Button Action Zone
    @IBAction func btnGridAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoadShapesVC")
        self.navigationController!.pushViewController(vc, animated: true)
//        let obj : LoadShapesVC = self.storyboard?.instantiateViewController(withIdentifier: "LoadShapesVC") as! LoadShapesVC
//        self.navigationController?.pushViewController(obj, animated: true)
    }
  
    @IBAction func btnEditAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let obj = storyboard.instantiateViewController(withIdentifier: "PresentPhotoVC") as! PresentPhotoVC
//        let obj = self.storyboard!.instantiateViewController(withIdentifier: "PresentPhotoVC") as! PresentPhotoVC
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


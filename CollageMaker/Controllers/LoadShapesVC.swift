//
//  LoadShapesVC.swift
//  Photo Collage Maker
//
//  Created by Grapes Infosoft on 14/09/19.
//  Copyright © 2019 Grapes Infosoft. All rights reserved.
//

import UIKit

class LoadShapesVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var pickImg = UIImage()
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ShapeCV: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ShapeCV.delegate = self
        ShapeCV.dataSource = self
        ShapeCV.register(UINib(nibName: "allFramesCell", bundle: nil), forCellWithReuseIdentifier: "allFramesCell")
        ShapeCV.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK:- Button Action Zone
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- CollectionView Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 59
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : allFramesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allFramesCell", for: indexPath) as! allFramesCell
        if cell.btnFrames == (cell.viewWithTag(40) as? UIButton) {
            cell.imgFrame.image = UIImage(named: "\(indexPath.row+1)")
            cell.btnFrames.mk_addTapHandlerIO { (btn) in
                btn.isEnabled = true
                let ind = indexPath.row
                if indexPath.row == arrOfIndex[indexPath.row]{
                    let obj = self.storyboard!.instantiateViewController(withIdentifier: "PresentPhotoVC") as! PresentPhotoVC
                    obj.objSelectiontype = 1
                    obj.objIndex = ind
                    self.totalSelection(ind, obj)
                    let navController = UINavigationController(rootViewController: obj)
                    navController.navigationBar.isHidden = true
                    navController.modalPresentationStyle = .overCurrentContext
                    self.present(navController, animated:true, completion: nil)
                }
            }
        }
        return cell
    }
    func totalSelection(_ total : Int, _ obj : PresentPhotoVC){
        if total == 0{
            obj.objTotalImgSelection = 2
        }else if total == 1{
            obj.objTotalImgSelection = 1
        }else if total == 2{
            obj.objTotalImgSelection = 1
        }else if total == 3{
            obj.objTotalImgSelection = 2
        }else if total == 4{
            obj.objTotalImgSelection = 2
        }else if total == 5{
            obj.objTotalImgSelection = 2
        }else if total == 6{
            obj.objTotalImgSelection = 2
        }else if total == 7{
            obj.objTotalImgSelection = 2
        }else if total == 8{
            obj.objTotalImgSelection = 2
        }else if total == 9{
            obj.objTotalImgSelection = 2
        }else if total == 10{
            obj.objTotalImgSelection = 2
        }else if total == 11{
            obj.objTotalImgSelection = 2
        }else if total == 12{
            obj.objTotalImgSelection = 2
        }else if total == 13{
            obj.objTotalImgSelection = 2
        }else if total == 14{
            obj.objTotalImgSelection = 2
        }else if total == 15{
            obj.objTotalImgSelection = 3
        }else if total == 16{
            obj.objTotalImgSelection = 3
        }else if total == 17{
            obj.objTotalImgSelection = 3
        }else if total == 18{
            obj.objTotalImgSelection = 3
        }else if total == 19{
            obj.objTotalImgSelection = 3
        }else if total == 20{
            obj.objTotalImgSelection = 3
        }else if total == 21{
            obj.objTotalImgSelection = 3
        }else if total == 22{
            obj.objTotalImgSelection = 3
        }else if total == 23{
            obj.objTotalImgSelection = 3
        }else if total == 24{
            obj.objTotalImgSelection = 3
        }else if total == 25{
            obj.objTotalImgSelection = 3
        }else if total == 26{
            obj.objTotalImgSelection = 3
        }else if total == 27{
            obj.objTotalImgSelection = 3
        }else if total == 28{
            obj.objTotalImgSelection = 3
        }else if total == 29{
            obj.objTotalImgSelection = 3
        }else if total == 30{
            obj.objTotalImgSelection = 3
        }else if total == 31{
            obj.objTotalImgSelection = 3
        }else if total == 32{
            obj.objTotalImgSelection = 4
        }else if total == 33{
            obj.objTotalImgSelection = 4
        }else if total == 34{
            obj.objTotalImgSelection = 4
        }else if total == 35{
            obj.objTotalImgSelection = 4
        }else if total == 36{
            obj.objTotalImgSelection = 4
        }else if total == 37{
            obj.objTotalImgSelection = 4
        }else if total == 38{
            obj.objTotalImgSelection = 4
        }else if total == 39{
            obj.objTotalImgSelection = 4
        }else if total == 40{
            obj.objTotalImgSelection = 4
        }else if total == 41{
            obj.objTotalImgSelection = 4
        }else if total == 42{
            obj.objTotalImgSelection = 4
        }else if total == 43{
            obj.objTotalImgSelection = 4
        }else if total == 44{
            obj.objTotalImgSelection = 4
        }else if total == 45{
            obj.objTotalImgSelection = 4
        }else if total == 46{
            obj.objTotalImgSelection = 4
        }else if total == 47{
            obj.objTotalImgSelection = 4
        }else if total == 48{
            obj.objTotalImgSelection = 4
        }else if total == 49{
            obj.objTotalImgSelection = 4
        }else if total == 50{
            obj.objTotalImgSelection = 4
        }else if total == 51{
            obj.objTotalImgSelection = 5
        }else if total == 52{
            obj.objTotalImgSelection = 5
        }else if total == 53{
            obj.objTotalImgSelection = 5
        }else if total == 54{
            obj.objTotalImgSelection = 5
        }else if total == 55{
            obj.objTotalImgSelection = 5
        }else if total == 56{
            obj.objTotalImgSelection = 5
        }else if total == 57{
            obj.objTotalImgSelection = 5
        }else if total == 58{
            obj.objTotalImgSelection = 5
        }else if total == 59{
            obj.objTotalImgSelection = 5
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
        IndexPath) -> CGSize {
        let width  = (ShapeCV.frame.width-30)/4
        return CGSize(width: width, height: width)
    }
}

////
//// Copyright (c) WhatsApp Inc. and its affiliates.
//// All rights reserved.
////
//// This source code is licensed under the BSD-style license found in the
//// LICENSE file in the root directory of this source tree.
////
//
//import UIKit
//
//class StickerPackInfoViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//    var imagePicker: UIImagePickerController!
//    
//    override func viewDidLoad() {
//        print("oi amigo")
//        setupImgProfile(profileImg: profileImg)
//    }
//
//    @IBOutlet weak var profileImg: UIImageView!
//    @IBAction func selectImgProfile(_ sender: Any) {
//        openGalery()
//    }
//
//    func openGalery() {
//
//        imagePicker =  UIImagePickerController()
//        imagePicker.allowsEditing = true
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//
//        present(imagePicker, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        var image : UIImage!
//
//        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//        {   image = img    }
//        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        {   image = img    }
//
//        profileImg.image = image
//        picker.dismiss(animated: true,completion: nil)
//
//        print(ProfileDataMenager().saveImage(image: image))
//    }
//
//    //    MARK: - Profile Image
//    //    Load
//        func setupImgProfile(profileImg: UIImageView) {
//            if let image = getSavedImage(named: "ProfileImg") {
//                profileImg.image = image
//            }
//        }
//
//        func getSavedImage(named: String) -> UIImage? {
//            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
//                return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
//            }
//            return nil
//        }
//
//    //    Save
//        func saveImage(image: UIImage) -> Bool {
//            guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
//                return false
//            }
//            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
//                return false
//            }
//            do {
//                try data.write(to: directory.appendingPathComponent("ProfileImg.png")!)
//                return true
//            } catch {
//                print(error.localizedDescription)
//                return false
//            }
//        }
//}

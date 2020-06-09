//
// Copyright (c) WhatsApp Inc. and its affiliates.
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//

import UIKit

class StickerPackViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet private weak var stickerPackPublisherLabel: UILabel!
    @IBOutlet private weak var stickersCollectionView: UICollectionView!
    @IBOutlet private weak var bottomCollectionViewConstraint: NSLayoutConstraint!
    
    private let topMarginInset: CGFloat = 5.0
    private let marginInset: CGFloat = 22
    private let interimMargin: CGFloat = 16.0
    private var itemsPerRow: Int = 4
    private let portraitItems = 4
    private let landscapeItems = 8
    
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    private var bottomGradientView: GradientView = GradientView(topColor: UIColor.white.withAlphaComponent(0.0), bottomColor: UIColor.white)
    private var topDivider: UIView = UIView()
    
    private var portraitOrientation: Bool {
        let currentOrientation = UIDevice.current.orientation
        return currentOrientation == .portrait || currentOrientation == .faceUp || currentOrientation == .faceDown || currentOrientation == .portraitUpsideDown
    }
    
    var stickerPack: StickerPack!
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        }
        
        if #available(iOS 10.0, *) {
            stickersCollectionView.isPrefetchingEnabled = false
        }
        
        stickersCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: "StickerCell")
        stickersCollectionView.scrollIndicatorInsets.bottom = 10
        
        itemsPerRow = portraitOrientation ? portraitItems : landscapeItems
        
        let infoButton: UIButton = UIButton(type: .contactAdd)
        infoButton.addTarget(self, action: #selector(infoPressed(button:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        bottomGradientView.isUserInteractionEnabled = false
        bottomGradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomGradientView)
        
        topDivider.isUserInteractionEnabled = false
        topDivider.backgroundColor = UIColor(red: 164.0/255.0, green: 164.0/255.0, blue: 164.0/255.0, alpha: 1.0).withAlphaComponent(0.2)
        topDivider.alpha = 0.0
        topDivider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topDivider)
        
        let shareImage: UIImage = UIImage(named: "ShareIcon")!.withRenderingMode(.alwaysTemplate)
        
        let addButton: AquaButton = AquaButton(frame: .zero)
        addButton.setTitle("Add to WhatsApp", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed(button:)), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.isEnabled = Interoperability.canSend()
        view.addSubview(addButton)
        
//        let shareButton: GrayRoundedButton = GrayRoundedButton(frame: .zero)
//        shareButton.setTitle("Share", for: .normal)
//        shareButton.setImage(shareImage, for: .normal)
//        shareButton.alpha = 0
//        shareButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(shareButton)
        
        stickerPackPublisherLabel.text = "\(stickerPack.publisher) • \(stickerPack.formattedSize)"
        
        let tapGuideLabel: UILabel = UILabel()
        tapGuideLabel.text = "Tap itens to see more"
        tapGuideLabel.font = UIFont.systemFont(ofSize: 15)
        tapGuideLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        tapGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tapGuideLabel)
        
        let buttonSize: CGSize = CGSize(width: 280.0, height: 50.0)
        let buttonLandscapeSize: CGSize = CGSize(width: 250.0, height: 50.0)
        let buttonBottomMargin: CGFloat = 20.0
        
        guard let view = view else { return }
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottomMargin, relatedBy: .equal, toItem: addButton, attribute: .bottom, multiplier: 1.0, constant: buttonBottomMargin))
        let centerPortraitShareConstraint = NSLayoutConstraint(item: view, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: addButton, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0)
        let centerLandscapeShareConstraint = NSLayoutConstraint(item: view, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: addButton, attribute: .centerXWithinMargins, multiplier: 1.0, constant: -buttonSize.width / 2.0 - 5.0)
        portraitConstraints.append(centerPortraitShareConstraint)
        landscapeConstraints.append(centerLandscapeShareConstraint)
        view.addConstraint(centerPortraitShareConstraint)
        view.addConstraint(centerLandscapeShareConstraint)
        let widthPortraitShareConstraint = NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: buttonSize.width)
        let widthLandscapeShareConstraint = NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: buttonLandscapeSize.width)
        addButton.addConstraint(widthPortraitShareConstraint)
        addButton.addConstraint(widthLandscapeShareConstraint)
        portraitConstraints.append(widthPortraitShareConstraint)
        landscapeConstraints.append(widthLandscapeShareConstraint)
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: buttonSize.height))
        
        // Add button constraints
//        let bottomPortraitAddConstraint = NSLayoutConstraint(item: shareButton, attribute: .top, relatedBy: .equal, toItem: addButton, attribute: .bottom, multiplier: 1.0, constant: 7.0)
//        let bottomLandscapeAddConstraint = NSLayoutConstraint(item: view, attribute: .bottomMargin, relatedBy: .equal, toItem: addButton, attribute: .bottom, multiplier: 1.0, constant: buttonBottomMargin)
//        portraitConstraints.append(bottomPortraitAddConstraint)
//        landscapeConstraints.append(bottomLandscapeAddConstraint)
//        view.addConstraint(bottomPortraitAddConstraint)
//        view.addConstraint(bottomLandscapeAddConstraint)
//        let centerPortraitAddConstraint = NSLayoutConstraint(item: view, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: addButton, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0)
//        let centerLandscapeAddConstraint = NSLayoutConstraint(item: view, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: addButton, attribute: .centerXWithinMargins, multiplier: 1.0, constant: buttonSize.width / 2.0 + 5.0)
//        portraitConstraints.append(centerPortraitAddConstraint)
//        landscapeConstraints.append(centerLandscapeAddConstraint)
//        view.addConstraint(centerPortraitAddConstraint)
//        view.addConstraint(centerLandscapeAddConstraint)
//        let widthPortraitAddConstraint = NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: buttonSize.width)
//        let widthLandscapeAddConstraint = NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: buttonLandscapeSize.width)
//        addButton.addConstraint(widthPortraitAddConstraint)
//        addButton.addConstraint(widthLandscapeAddConstraint)
//        portraitConstraints.append(widthPortraitAddConstraint)
//        landscapeConstraints.append(widthLandscapeAddConstraint)
//        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: buttonSize.height))
        
        // Tap guide label constraints
        view.addConstraint(NSLayoutConstraint(item: addButton, attribute: .top, relatedBy: .equal, toItem: tapGuideLabel, attribute: .bottom, multiplier: 1.0, constant: 14.0))
        view.addConstraint(NSLayoutConstraint(item: tapGuideLabel, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: view, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tapGuideLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: tapGuideLabel, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        // Collection view constraint
        var bottomCollectionViewConstraint = self.bottomCollectionViewConstraint!
        view.removeConstraint(bottomCollectionViewConstraint)
        bottomCollectionViewConstraint = NSLayoutConstraint(item: tapGuideLabel, attribute: .top, relatedBy: .equal, toItem: stickersCollectionView, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        view.addConstraint(bottomCollectionViewConstraint)
        
        // Gradient constraints
        view.addConstraint(NSLayoutConstraint(item: bottomGradientView, attribute: .bottom, relatedBy: .equal, toItem: stickersCollectionView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: bottomGradientView, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: view, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: bottomGradientView, attribute: .width, relatedBy: .equal, toItem: stickersCollectionView, attribute: .width, multiplier: 1.0, constant: 0.0))
        bottomGradientView.addConstraint(NSLayoutConstraint(item: bottomGradientView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50.0))
        
        // Top divider constraints
        view.addConstraint(NSLayoutConstraint(item: topDivider, attribute: .top, relatedBy: .equal, toItem: stickersCollectionView, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: topDivider, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: topDivider, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        topDivider.addConstraint(NSLayoutConstraint(item: topDivider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1.0))
        
        changeConstraints()
    }
    
    private func changeConstraints() {
        portraitConstraints.forEach { $0.isActive = portraitOrientation }
        landscapeConstraints.forEach { $0.isActive = !portraitOrientation }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        itemsPerRow = portraitOrientation ? portraitItems : landscapeItems
        changeConstraints()
    }
    
    // MARK: Scrollview
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > topMarginInset {
            topDivider.alpha = 1.0
        } else {
            topDivider.alpha = 0.0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > topMarginInset {
            topDivider.alpha = 1.0
        } else {
            topDivider.alpha = 0.0
        }
    }
    
    // MARK: Collectionview
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interimMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topMarginInset, left: marginInset, bottom: 60, right: marginInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (collectionView.bounds.size.width - marginInset * 2 - interimMargin * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow)
        return CGSize(width: length, height: length)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickerPack.stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerCell
        cell.sticker = stickerPack.stickers[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sticker: Sticker = stickerPack.stickers[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath)
        showActionSheet(withSticker: sticker, overCell: cell!)
    }
    
    // MARK: Targets
    
    func showActionSheet(withSticker sticker: Sticker, overCell cell: UICollectionViewCell) {
        var emojisString: String?
        
        #if DEBUG
        if let emojis = sticker.emojis {
            emojisString = emojis.joined(separator: " ")
        }
        #endif
        
        let actionSheet: UIAlertController = UIAlertController(title: "\n\n\n\n\n\n", message: emojisString, preferredStyle: .actionSheet)
        
        actionSheet.popoverPresentationController?.sourceView = cell.contentView
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: cell.contentView.bounds.midX, y: cell.contentView.bounds.midY, width: 0, height: 0)
        
        actionSheet.addAction(UIAlertAction(title: "Copy to Clipboard", style: .default, handler: { _ in
            sticker.copyToPasteboardAsImage()
        }))
        actionSheet.addAction(UIAlertAction(title: "Share via", style: .default, handler: { _ in
            self.showShareSheet(withSticker: sticker)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let stickerImage = sticker.imageData.image {
            actionSheet.addImageView(withImage: stickerImage)
        }
        present(actionSheet, animated: true)
    }
    
    func showShareSheet(withSticker sticker: Sticker) {
        guard let image = sticker.imageData.image else { return }
        
        let shareViewController: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = self.view
        shareViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        shareViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(shareViewController, animated: true)
    }
    
    @objc func infoPressed(button: UIButton) {
        openGalery()
    }
    
    func openGalery() {
        
        imagePicker =  UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            var auxImg = img
            if(img.size.width > img.size.height) {
                auxImg = ImageFunctions().cropToBounds(image: img, width: Double(img.size.width), height: Double(img.size.width))
            }
            else {
                auxImg = ImageFunctions().cropToBounds(image: img, width: Double(img.size.height), height: Double(img.size.height))
            }
            
            image = resizeImage(image: auxImg, targetSize: CGSize(width: 512, height: 512))
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {   image = img    }
        
        picker.dismiss(animated: true,completion: nil)
        
        print(ProfileDataMenager().saveImage(image: image))
        
        aaaRefresh()
    }
    
    func aaaRefresh() {
        do {
            var image = UIImage(named: "oiaa.png")!
            if let image2 = getSavedImage(named: "ProfileImg") {
                image = image2
            }
            
            var sticker: Sticker = try Sticker(contentsOfFile: "placeholderGreen.png", emojis: nil)
            let aux = image.resizeToApprox(sizeInMB: 0.01)
            let imageData = ImageData(data: aux, type: ImageDataExtension.png)
            sticker.imageData = imageData
            stickerPack!.stickers.append(sticker)
        } catch {
            print(error)
        }
        
        stickersCollectionView.reloadData()
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    //    MARK: - Profile Image
    //    Load
    func setupImgProfile(profileImg: UIImageView) {
        if let image = getSavedImage(named: "ProfileImg") {
            profileImg.image = image
        }
    }
    
    //    Save
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("ProfileImg.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @objc func addButtonPressed(button: AquaButton) {
        let loadingAlert: UIAlertController = UIAlertController(title: "Sending to WhatsApp", message: "\n\n", preferredStyle: .alert)
        loadingAlert.addSpinner()
        present(loadingAlert, animated: true)
        print("------------")
        print("enviando para o whats")
        stickerPack.sendToWhatsApp { completed in
            loadingAlert.dismiss(animated: true)
        }
    }
    
    @objc func shareButtonPressed(button: GrayRoundedButton) {
        var stickerImages: [UIImage] = []
        
        for sticker in stickerPack.stickers {
            if let image = sticker.imageData.image {
                stickerImages.append(image)
            }
        }
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: stickerImages, applicationActivities: nil)
        let parentView = button as UIView
        activityViewController.popoverPresentationController?.sourceView = parentView
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: parentView.bounds.midX, y: parentView.bounds.midY, width: 0, height: 0)
        present(activityViewController, animated: true)
    }
}

extension UIImage {
    func resizeToApprox(sizeInMB: Double, deltaInMB: Double = 0.2) -> Data {
        let allowedSizeInBytes = Int(sizeInMB * 1024 * 1024)
        let deltaInBytes = Int(deltaInMB * 1024 * 1024)
        let fullResImage = self.jpegData(compressionQuality: 1.0)
        if (fullResImage?.count)! < Int(deltaInBytes + allowedSizeInBytes) {
            return fullResImage!
        }

        var i = 0

        var left:CGFloat = 0.0, right: CGFloat = 1.0
        var mid = (left + right) / 2.0
        var newResImage = self.jpegData(compressionQuality: mid)

        while (true) {
            i += 1
            if (i > 13) {
                print("Compression ran too many times ") // ideally max should be 7 times as  log(base 2) 100 = 6.6
                break
            }


            print("mid = \(mid)")

            if ((newResImage?.count)! < (allowedSizeInBytes - deltaInBytes)) {
                left = mid
            } else if ((newResImage?.count)! > (allowedSizeInBytes + deltaInBytes)) {
                right = mid
            } else {
                print("loop ran \(i) times")
                return newResImage!
            }
             mid = (left + right) / 2.0
            newResImage = self.jpegData(compressionQuality: mid)

        }

        return self.jpegData(compressionQuality: 0.5)!
    }
}

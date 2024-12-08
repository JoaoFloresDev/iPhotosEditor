//
//  HomePageViewController.swift
//  iPhotos
//
//  Created by Joao Victor Flores da Costa on 18/10/23.
//  Copyright © 2023 WhatsApp. All rights reserved.
//
import StoreKit
import SwiftUI
import Foundation
import UIKit
import SnapKit

class HomePageViewController: UIViewController {
    
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "portrait-beautiful-young-model-black-leather-jacket-posing-near-lamps")
        return imageView
    }()
    
    lazy var containerStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 24
        return stackview
    }()
    
    lazy var editOptionsStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 24
        return stackview
    }()
    
    lazy var collageOptionsStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 24
        return stackview
    }()
    
    lazy var beautyOptionsStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 24
        return stackview
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "iPhotos"
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    lazy var premiumVersionButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "be-premium"), for: .normal)
        button.addTarget(self, action: #selector(purchaseAction), for: .touchUpInside)
        return button
    }()
    
    lazy var stickersButton = ImageButton(withImage: UIImage(named: "novo-chat"), andText: "Stickers", action: stickersButtonAction)
    lazy var augmentedReallityButton = ImageButton(withImage: UIImage(named: "virtual-reality"), andText: "AR", action: augmentedReallityButtonAction)
    lazy var collageButton = ImageButton(withImage: UIImage(named: "stickerImage"), andText: "Collage", action: collageButtonAction)
    lazy var gridButton = ImageButton(withImage: UIImage(named: "22"), andText: "Grid", action: gridButtonAction)
    
    lazy var retouchButton = ImageButton(withImage: UIImage(systemName: "sparkles"), andText: "Retouch", action: retouchButtonAction)
    lazy var beutifyButton = ImageButton(withImage: UIImage(systemName: "camera"), andText: "Filters", action: beutifyButtonAction)
    
    lazy var editPhotoButton = TextButton(text: "Edit Photo", action: editPhotoButtonAction)
    
    override func viewDidLoad() {
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestReviewIfNeeded()
    }

    func requestReviewIfNeeded() {
        let launchCountKey = "launchCount_iPhotos"
        var launchCount = UserDefaults.standard.integer(forKey: launchCountKey)
        
        launchCount += 1
        UserDefaults.standard.set(launchCount, forKey: launchCountKey)
        
        if launchCount % 8 == 0 {
            requestReview()
        } else if launchCount == 16 {
            showImprovementSuggestionAlert(on: self)
        } else if launchCount > 26 {
            if !(RazeFaceProducts.store.isProductPurchased("NoAds.iPhotos") || (UserDefaults.standard.object(forKey: "NoAds.iPhotos") != nil)) {
                purchaseAction()
            }
        }
    }

    func requestReview() {
        if #available(iOS 14.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        } else if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    func showImprovementSuggestionAlert(on viewController: UIViewController) {
        let alertController = UIAlertController(
            title: "Suggestions for improvement?",
            message: "Your feedback is very important! Help us get even better.",
            preferredStyle: .alert
        )
        
        let rateAction = UIAlertAction(title: "Rate now", style: .default) { _ in
            let appID = "1517929511"
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let laterAction = UIAlertAction(title: "Not now", style: .cancel, handler: nil)
        
        alertController.addAction(rateAction)
        alertController.addAction(laterAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func saveTodayDate() {
        let now = Date()
        UserDefaults.standard.set(now, forKey: "LastSavedDate")
    }
    
    func setupViews() {
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(premiumVersionButton)
        view.addSubview(containerStack)
        containerStack.addArrangedSubview(editOptionsStack)
        containerStack.addArrangedSubview(beautyOptionsStack)
        containerStack.addArrangedSubview(collageOptionsStack)
        containerStack.addArrangedSubview(editPhotoButton)
        
        editOptionsStack.addArrangedSubview(gridButton)
        editOptionsStack.addArrangedSubview(augmentedReallityButton)
        
        collageOptionsStack.addArrangedSubview(collageButton)
        collageOptionsStack.addArrangedSubview(stickersButton)
        
        beautyOptionsStack.addArrangedSubview(retouchButton)
        beautyOptionsStack.addArrangedSubview(beutifyButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        premiumVersionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.height.equalTo(48)
            make.width.equalTo(48)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(32)
        }
        
        containerStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
        }
        
        // Configurando os botões para terem o mesmo tamanho
        stickersButton.snp.makeConstraints { make in
            make.width.equalTo(augmentedReallityButton)
            make.height.equalTo(90)
        }
        
        augmentedReallityButton.snp.makeConstraints { make in
            make.width.equalTo(collageButton)
            make.height.equalTo(90)
        }

        collageButton.snp.makeConstraints { make in
            make.width.equalTo(gridButton)
            make.height.equalTo(90)
        }
        
        retouchButton.snp.makeConstraints { make in
            make.width.equalTo(gridButton)
            make.height.equalTo(90)
        }
        
        beutifyButton.snp.makeConstraints { make in
            make.width.equalTo(gridButton)
            make.height.equalTo(90)
        }
        
        editPhotoButton.snp.makeConstraints { make in
            let height: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 90 : 64
            make.height.equalTo(height)
        }

    }
}

extension HomePageViewController {
    func stickersButtonAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AllStickerPacksViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collageButtonAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let obj = storyboard.instantiateViewController(withIdentifier: "PresentPhotoVC") as! PresentPhotoVC
        obj.objSelectiontype = 2
        let navController = UINavigationController(rootViewController: obj)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .overCurrentContext
        self.present(navController, animated:true, completion: nil)
    }
    
    func augmentedReallityButtonAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func gridButtonAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let obj : LoadShapesVC = storyboard.instantiateViewController(withIdentifier: "LoadShapesVC") as? LoadShapesVC else {
            return
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func beutifyButtonAction() {
        let photoEditView = PhotoEditView(image: UIImage(named: "sample"))
            .environmentObject(PECtl.shared)
            .environmentObject(Data123.shared)
        
        let hostingController = UIHostingController(rootView: photoEditView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
    
    func retouchButtonAction() {
        let controller = ImageEditorViewController()
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    func editPhotoButtonAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc
    func purchaseAction() {
        let controller = PurchaseViewController()
        let navigation = UINavigationController(rootViewController: controller)
        present(navigation, animated: true)
    }
}

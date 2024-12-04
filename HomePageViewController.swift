//
//  HomePageViewController.swift
//  iPhotos
//
//  Created by Joao Victor Flores da Costa on 18/10/23.
//  Copyright © 2023 WhatsApp. All rights reserved.
//
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
    
    lazy var retouchButton = TextButton(text: "Retouch", action: retouchButtonAction)
    
    lazy var beutifyButton = TextButton(text: "Filters", action: beutifyButtonAction)
    
    lazy var editPhotoButton = TextButton(text: "Edit Photo", action: editPhotoButtonAction)
    
    override func viewDidLoad() {
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !(RazeFaceProducts.store.isProductPurchased("NoAds.iPhotos") || (UserDefaults.standard.object(forKey: "NoAds.iPhotos") != nil)) {
            if check30DaysPassed() {
                purchaseAction()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func saveTodayDate() {
        let now = Date()
        UserDefaults.standard.set(now, forKey: "LastSavedDate")
    }

    func check30DaysPassed() -> Bool {
        if let lastSavedDate = UserDefaults.standard.object(forKey: "LastSavedDate") as? Date {
            let dayDifference = Calendar.current.dateComponents([.day], from: lastSavedDate, to: Date()).day ?? 0
            if dayDifference >= 17 {
                saveTodayDate()
                return true
            } else {
                return false
            }
        }
        saveTodayDate()
        return false
    }
    
    func setupViews() {
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(premiumVersionButton)
        view.addSubview(containerStack)
        containerStack.addArrangedSubview(editOptionsStack)
        containerStack.addArrangedSubview(collageOptionsStack)
        containerStack.addArrangedSubview(editPhotoButton)
        containerStack.addArrangedSubview(retouchButton)
        containerStack.addArrangedSubview(beutifyButton)
        
        editOptionsStack.addArrangedSubview(gridButton)
        editOptionsStack.addArrangedSubview(augmentedReallityButton)
        
        collageOptionsStack.addArrangedSubview(collageButton)
        collageOptionsStack.addArrangedSubview(stickersButton)
        
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
            make.height.equalTo(54)
        }
        
        beutifyButton.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        
        editPhotoButton.snp.makeConstraints { make in
            make.height.equalTo(54)
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
        let photoEditView = PhotoEditView(image: UIImage(named: "sample")) // Substitua por uma imagem padrão válida
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

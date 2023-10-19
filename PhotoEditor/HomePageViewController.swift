//
//  HomePageViewController.swift
//  iPhotos
//
//  Created by Joao Victor Flores da Costa on 18/10/23.
//  Copyright © 2023 WhatsApp. All rights reserved.
//

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
    
    lazy var stickersButton = ImageButton(withImage: UIImage(named: "tag"), andText: "Stickers")
    lazy var augmentedReallityButton = ImageButton(withImage: UIImage(named: "filter1"), andText: "Augmented Reallity")
    
    lazy var collageButton = ImageButton(withImage: UIImage(named: "stickerImage"), andText: "Collage")
    lazy var gridButton = ImageButton(withImage: UIImage(named: "22"), andText: "Grid")
    
    lazy var editPhotoButton = TextButton(text: "Edit Photo")
    lazy var premiumVersionButton = TextButton(text: "Premium version")
    
    override func viewDidLoad() {
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(containerStack)
        containerStack.addArrangedSubview(editOptionsStack)
        containerStack.addArrangedSubview(collageOptionsStack)
        containerStack.addArrangedSubview(editPhotoButton)
        containerStack.addArrangedSubview(premiumVersionButton)
        
        editOptionsStack.addArrangedSubview(stickersButton)
        editOptionsStack.addArrangedSubview(augmentedReallityButton)
        
        collageOptionsStack.addArrangedSubview(collageButton)
        collageOptionsStack.addArrangedSubview(gridButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(32)
        }
        
        containerStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
        }
        
        // Configurando os botões para terem o mesmo tamanho
        stickersButton.snp.makeConstraints { make in
            make.width.equalTo(augmentedReallityButton)
            make.height.equalTo(120)
        }
        
        augmentedReallityButton.snp.makeConstraints { make in
            make.width.equalTo(collageButton)
            make.height.equalTo(120)
        }

        collageButton.snp.makeConstraints { make in
            make.width.equalTo(gridButton)
            make.height.equalTo(120)
        }
        
        editPhotoButton.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        premiumVersionButton.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
    }
}

class ImageButton: UIButton {
    
    // MARK: - Properties
    
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    init(withImage image: UIImage?, andText text: String) {
        super.init(frame: .zero)
        topImageView.image = image
        bottomLabel.text = text
        bottomLabel.textColor = .white
        bottomLabel.font = .boldSystemFont(ofSize: 18)
        setupViews()
        setupButtonAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupButtonAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupButtonAppearance()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addSubview(topImageView)
        addSubview(bottomLabel)

        topImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(20)
        }
        
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(50)
        }
    }
    
    private func setupButtonAppearance() {
        // Arredondando os cantos
        self.layer.cornerRadius = 10
        
        // Adicionando sombra
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor(hex: "FF6079").cgColor, UIColor(hex: "D73852").cgColor]
        gradientLayer.cornerRadius = 10
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

class TextButton: UIButton {
    // MARK: - Properties
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    init(text: String) {
        super.init(frame: .zero)
        bottomLabel.text = text
        bottomLabel.textColor = .white
        bottomLabel.font = .boldSystemFont(ofSize: 18)
        setupViews()
        setupButtonAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupButtonAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupButtonAppearance()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addSubview(bottomLabel)
        
        bottomLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func setupButtonAppearance() {
        // Arredondando os cantos
        self.layer.cornerRadius = 10
        
        // Adicionando sombra
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor(hex: "FF6079").cgColor, UIColor(hex: "D73852").cgColor]
        gradientLayer.cornerRadius = 10
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

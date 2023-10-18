//
//  HomeViewController.swift
//  iPhotos
//
//  Created by Joao Victor Flores da Costa on 18/10/23.
//  Copyright © 2023 WhatsApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "portrait-beautiful-young-model-black-leather-jacket-posing-near-lamps")
        return imageView
    }()
    
    lazy var containerStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.backgroundColor = .blue
        stackview.distribution = .fillEqually
        return stackview
    }()
    
    lazy var editOptionsStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.backgroundColor = .purple
        return stackview
    }()
    
    lazy var collageOptionsStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.backgroundColor = .red
        return stackview
    }()
    
    lazy var editPhotoButton = ImageButton(withImage: UIImage(named: "editPencil"), andText: "Edit Photo")
    lazy var augmentedReallityButton = ImageButton(withImage: UIImage(named: "filter1"), andText: "Augmented Reallity")
    
    lazy var collageButton = ImageButton(withImage: UIImage(named: "stickerImage"), andText: "Collage")
    lazy var gridButton = ImageButton(withImage: UIImage(named: "22"), andText: "Grid")
    
    lazy var stickersButton = ImageButton(withImage: UIImage(named: "tag"), andText: "Stickers")
    
    override func viewDidLoad() {
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(containerStack)
        containerStack.addArrangedSubview(editOptionsStack)
        containerStack.addArrangedSubview(collageOptionsStack)
        
        editOptionsStack.addArrangedSubview(editPhotoButton)
        editOptionsStack.addArrangedSubview(augmentedReallityButton)
        
        collageOptionsStack.addArrangedSubview(collageButton)
        collageOptionsStack.addArrangedSubview(gridButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        return label
    }()
    
    // MARK: - Initializers
    init(withImage image: UIImage?, andText text: String) {
        super.init(frame: .zero)
        configure(withImage: image, andText: text)
        backgroundColor = .green
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addSubview(topImageView)
        addSubview(bottomLabel)

        topImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topImageView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
    }
    
    // MARK: - Public Methods
    
    func configure(withImage image: UIImage?, andText text: String) {
        topImageView.image = image
        bottomLabel.text = text
    }
}


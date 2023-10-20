import Foundation
import UIKit
import SnapKit

class ImageButton: UIButton {
    typealias ButtonAction = () -> Void
    private var buttonAction: ButtonAction?

    // MARK: - Properties
    
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    init(withImage image: UIImage?, andText text: String, action: ButtonAction? = nil) {
        super.init(frame: .zero)
        topImageView.image = image
        bottomLabel.text = text
        bottomLabel.textColor = .white
        bottomLabel.font = .systemFont(ofSize: 14)
        buttonAction = action
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
            make.top.equalToSuperview().inset(12)
        }
        
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(4)
            make.height.equalTo(30)
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
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
}

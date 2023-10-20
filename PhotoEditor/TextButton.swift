import Foundation
import UIKit
import SnapKit

class TextButton: UIButton {
    typealias ButtonAction = () -> Void
    private var buttonAction: ButtonAction?
    
    // MARK: - Properties
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    init(text: String, action: ButtonAction? = nil) {
        super.init(frame: .zero)
        bottomLabel.text = text
        bottomLabel.textColor = .white
        bottomLabel.font = .boldSystemFont(ofSize: 18)
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
        addSubview(bottomLabel)
        
        bottomLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func setupButtonAppearance() {
        self.layer.cornerRadius = 10
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

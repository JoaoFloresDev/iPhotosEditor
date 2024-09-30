import UIKit
import SnapKit

enum ButtonActions {
    case changeColor
    case record
    case addImage
    case location
    case bubbles
    case photoStorm
}

protocol ExpandableViewDelegate: AnyObject {
    func didSelect(item: ButtonActions)
}

extension UIView {
    func applyGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

class ExpandableView: UIView {
    
    weak var delegate: ExpandableViewDelegate?
    
    let edges = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    private lazy var translucentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    private lazy var showMoreButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "arrow 1")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var changeColorButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "color1")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(changeColorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var recordButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "gravar")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "addImage")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "pin")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var bubblesButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "sabonete")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = edges
        button.addTarget(self, action: #selector(bubblesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var photoStormButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "tornado")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = edges
        button.addTarget(self, action: #selector(photoStormButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var isExpanded = true
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [showMoreButton, buttonStackView, hiddenButtonStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeColorButton, recordButton, addImageButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var hiddenButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationButton, bubblesButton, photoStormButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(translucentView)
        addSubview(mainStackView)
        
        showMoreButton.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
                
        translucentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        showMoreButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        hiddenButtonStackView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
    }
    
    @objc private func toggleExpand() {
        isExpanded.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.showMoreButton.imageView?.flipVertically()
            self.hiddenButtonStackView.arrangedSubviews.forEach { $0.alpha = self.isExpanded ? 1 : 0 }
            self.hiddenButtonStackView.isHidden = !self.isExpanded
            self.mainStackView.layoutIfNeeded()
        }
    }
    
    @objc private func changeColorButtonTapped() {
        delegate?.didSelect(item: .changeColor)
    }
    
    @objc private func recordButtonTapped() {
        delegate?.didSelect(item: .record)
    }
    
    @objc private func addImageButtonTapped() {
        delegate?.didSelect(item: .addImage)
    }
    
    @objc private func locationButtonTapped() {
        delegate?.didSelect(item: .location)
    }
    
    @objc private func bubblesButtonTapped() {
        delegate?.didSelect(item: .bubbles)
    }
    
    @objc private func photoStormButtonTapped() {
        delegate?.didSelect(item: .photoStorm)
    }
    
    public func setChangeColorButtonImage(named: String) {
        changeColorButton.setImage(UIImage(named: named)!, for: .normal)
    }
    
    public func setChangeRecordButtonImage(named: String) {
        recordButton.setImage(UIImage(named: named)!, for: .normal)
    }
}

extension UIImageView {
    func flipVertically() {
        UIView.animate(withDuration: 0.3) {
            self.transform = self.transform.scaledBy(x: 1, y: -1)
        }
    }
}

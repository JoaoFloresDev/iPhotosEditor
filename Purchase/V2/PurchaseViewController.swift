import UIKit
import StoreKit
import SnapKit

protocol PurchaseViewControllerDelegate: AnyObject {
    func purchased()
}

class PurchaseViewController: UIViewController {

    weak var delegate: PurchaseViewControllerDelegate?
    
    // MARK: - Variables
    private var products: [SKProduct] = []
    private var timerLoad: Timer?
    
    private lazy var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        setupUI()
    }
    
    lazy var headerView = PurchaseHeaderView()
    lazy var purchaseBenetList = PurchaseBenetList()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0/255.0, green: 175/255.0, blue: 232/255.0, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.clipsToBounds = true
        button.setTitle("Continuar", for: .normal)
        
        // Adicionando a ação ao botão
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        return button
    }()
    
    @objc func didTapActionButton() {
        performPurchase(product: products.first)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        self.navigationItem.title = "Close"
        let close = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped))
        self.navigationItem.leftBarButtonItem = close
        
        let restorePurchase = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchaseTapped))
        self.navigationItem.rightBarButtonItem = restorePurchase
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(56)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(purchaseBenetList)
        purchaseBenetList.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(255)
            make.centerX.equalToSuperview().multipliedBy(1.05)
            make.width.equalTo(280)
        }
        
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.top.equalTo(purchaseBenetList.snp.bottom).offset(35)
        }
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func restorePurchaseTapped() {
        RazeFaceProducts.store.restorePurchases()
        confirmCheckmark()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadAndCheckPurchaseStatus()
    }
    
    // MARK: - Helper Methods
    private func setupObservers() {
        setupNotificationObserver()
    }
    
    private func postNotification(named name: String) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: nil)
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: .IAPHelperPurchaseNotification, object: nil)
    }
    
    @objc private func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String, products.contains(where: { $0.productIdentifier == productID }) else { return }
        confirmCheckmark()
    }
    
    private func performPurchase(product: SKProduct?) {
        guard let product = product else { return }
        RazeFaceProducts.store.buyProduct(product)
        confirmCheckmark()
    }
    
    private func reloadAndCheckPurchaseStatus() {
        reload()
        confirmCheckmark()
    }
    
    @objc private func reload() {
        products = []
        RazeFaceProducts.store.requestProducts { [weak self] success, products in
            guard let self = self, let products = products else { return }
            DispatchQueue.main.async {
                self.products = products
                self.updateUI(with: products.first)
                self.confirmCheckmark()
            }
        }
    }
    
    private func confirmCheckmark() {
        DispatchQueue.main.async {
            if RazeFaceProducts.store.isProductPurchased("NoAds.iPhotos") {
                self.actionButton.setTitle("✓✓✓", for: .normal)
                self.actionButton.backgroundColor  = .systemGreen
                self.actionButton.isUserInteractionEnabled = false
                UserDefaults.standard.set(true, forKey:"NoAds.iPhotos")
                self.delegate?.purchased()
            }
        }
    }
    
    private func updateUI(with product: SKProduct?) {
        guard let product = product else { return }
        headerView.title.text  = product.localizedTitle
        headerView.subtitle.text = product.localizedDescription
        priceFormatter.locale = product.priceLocale
        headerView.price.text = priceFormatter.string(from: product.price)
    }
}

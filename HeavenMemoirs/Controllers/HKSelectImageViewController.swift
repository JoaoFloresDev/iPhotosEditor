import UIKit
import Photos

let identifier_Box: String = "HKImageCollectionViewCell_Box"
let identifier_H: String = "HKImageCollectionViewCell_H"
let identifier_V: String = "HKImageCollectionViewCell_V"

class HKSelectImageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var rowBackViews: [UIView]!
    @IBOutlet weak var collectionView_Box: UICollectionView!
    @IBOutlet weak var collectionView_H: UICollectionView!
    @IBOutlet weak var collectionView_V: UICollectionView!
    
    @IBOutlet weak var textContrantField: UITextField!
    
    @IBOutlet weak var textView_H: NSLayoutConstraint!
    @IBOutlet weak var particleView_H: NSLayoutConstraint!
    @IBOutlet weak var scrollView_Bottom: NSLayoutConstraint!
    
    // MARK: Swith
    @IBOutlet weak var boxRandomSwitch: UISwitch!
    @IBOutlet weak var textSwitch: UISwitch!
    @IBOutlet weak var particleSwitch: UISwitch!
    var containerCollectionView: UICollectionView?
    
    // MARK: Button
    var textColorButton: UIButton?
    @IBOutlet var textColorButtons: [UIButton]!
    @IBOutlet var particleButtons: [UIButton]!
    
    let rescouceManager = RescouceManager.share

    let rescoucceConfiguration = RescouceConfiguration.share
    var box_Delete: Bool = false {
        didSet {
            for cell in collectionView_Box.visibleCells {
                cellShake(cell: cell, shake: box_Delete)
            }
        }
    }
    
    var H_Delete: Bool = false {
        didSet {
            for cell in collectionView_H.visibleCells {
                cellShake(cell: cell, shake: H_Delete)
            }
        }
    }
    
    var V_Delete: Bool = false {
        didSet {
            for cell in collectionView_V.visibleCells {
                cellShake(cell: cell, shake: V_Delete)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        addObserver()
        updateUI()
        addShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func registerCell() {
        collectionView_Box.register(HKImageCollectionViewCell.self, forCellWithReuseIdentifier: identifier_Box)
        collectionView_H.register(HKImageCollectionViewCell.self, forCellWithReuseIdentifier: identifier_H)
        collectionView_V.register(HKImageCollectionViewCell.self, forCellWithReuseIdentifier: identifier_V)
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(deleteImage(notify:)), name: NSNotification.Name("Notification_NAME_ImageDelete"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    func addShadow() {
        for view in rowBackViews {
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 4.0
            view.layer.shadowOffset = CGSize(width: 4, height: 4)
            view.layer.cornerRadius = 4.0
        }
    }
    
    func updateUI() {
        setSwitch()
        updateText()
        let button = particleButtons[rescouceManager.particleType]
            button.isSelected = true
    }
    
    func updateText() {
        if let text = rescouceManager.text {
            textContrantField.text = text
            for button in textColorButtons where button.currentTitle == rescouceManager.textColor {
                    button.isSelected = true
                    textColorButton = button
            }
        } else {
            textColorButtons.first?.isSelected = true
            textColorButton = textColorButtons.first
        }
    }
    
    func setRescoucceConfiguration() {
        rescoucceConfiguration.box_Random           = boxRandomSwitch.isOn
        rescoucceConfiguration.text_isShow          = textSwitch.isOn
        rescoucceConfiguration.particle_isShow      = particleSwitch.isOn
    }
    
    func setSwitch() {
        boxRandomSwitch.setOn(rescoucceConfiguration.box_Random, animated: false)
        textSwitch.setOn(rescoucceConfiguration.text_isShow, animated: false)
        particleSwitch.setOn(rescoucceConfiguration.particle_isShow, animated: false)
        textView_H.constant         = textSwitch.isOn ? 200 : 46
        particleView_H.constant      = particleSwitch.isOn ? 100 : 46
    }
    
    func cellShake(cell: UICollectionViewCell, shake: Bool) {
        let newCell = cell as! HKImageCollectionViewCell
        newCell.cellShake(shake: shake)
    }
    
    func cancelDelete() {
        box_Delete = false
        H_Delete   = false
        V_Delete   = false
    }
    
    var imagePicker: UIImagePickerController?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Verifica se a imagem editada está disponível
        if let editedImage = info[.editedImage] as? UIImage {
            handleImageSelection(image: editedImage)
        }
        // Verifica se a imagem original está disponível
        else if let originalImage = info[.originalImage] as? UIImage {
            handleImageSelection(image: originalImage)
        }
        
        // Atualiza a collection view e fecha o picker
        containerCollectionView?.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }

    private func handleImageSelection(image: UIImage) {
        if self.containerCollectionView == collectionView_Box {
            rescouceManager.addBoxImage(image: image)
        } else if self.containerCollectionView == collectionView_H {
            rescouceManager.addHorizontalImage(image: image)
        } else if self.containerCollectionView == collectionView_V {
            rescouceManager.addVerticalImage(image: image)
        }
    }

}

extension HKSelectImageViewController {
    @IBAction func boxAddButtonDidClick(_ sender: UIButton) {
        containerCollectionView = collectionView_Box
        imagePicVc()
        cancelDelete()
    }
    
    @IBAction func addButtonDidClick_H(_ sender: UIButton) {
        containerCollectionView = collectionView_H
        imagePicVc()
        cancelDelete()
    }
    
    @IBAction func addButtonDidClick_V(_ sender: UIButton) {
        containerCollectionView = collectionView_V
        imagePicVc()
        cancelDelete()
    }
    
    func imagePicVc() {
        imagePicker =  UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.mediaTypes = ["public.image"]
        
        if let imagePicker = imagePicker {
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func boxDeleteButtonDidClick(_ sender: UIButton) {
        containerCollectionView = collectionView_Box
        box_Delete = !box_Delete
    }
    
    @IBAction func deletaButtonDidClick_H(_ sender: UIButton) {
        containerCollectionView = collectionView_H
        H_Delete = !H_Delete
    }
    
    @IBAction func deleteButtonDidClick_V(_ sender: UIButton) {
        containerCollectionView = collectionView_V
        V_Delete = !V_Delete
    }
    
    @objc func deleteImage(notify: Notification) {
        let newCell = notify.object as! HKImageCollectionViewCell
        switch newCell.reuseIdentifier! {
        case identifier_Box:
            if let indexPath = collectionView_Box.indexPath(for: newCell) {
                if indexPath.row <= rescouceManager.boxImages.count {
                    rescouceManager.boxImages.remove(at: indexPath.row)
                    collectionView_Box.deleteItems(at: [indexPath])
                }
            }
        case identifier_H:
            if let indexPath = collectionView_H.indexPath(for: newCell) {
                if indexPath.row <= rescouceManager.horizontalImages.count {
                    rescouceManager.horizontalImages.remove(at: indexPath.row)
                    collectionView_H.deleteItems(at: [indexPath])
                }
            }
        case identifier_V:
            if let indexPath = collectionView_V.indexPath(for: newCell) {
                if indexPath.row <= rescouceManager.verticalImages.count {
                    rescouceManager.verticalImages.remove(at: indexPath.row)
                    collectionView_V.deleteItems(at: [indexPath])
                }
            }
        default: break
        }
    }
    
    @IBAction func particleButtonDidClick(_ sender: UIButton) {
        for button in particleButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        let teg = sender.tag - 10086
        rescouceManager.particleType = teg
    }
    
    @IBAction func textColorButtonDidClick(_ sender: UIButton) {
        textColorButton?.isSelected = false
        textColorButton = sender
        textColorButton?.isSelected = true
        rescouceManager.textColor = sender.currentTitle!
    }
    
    @IBAction func supportButtonDidClick(_ sender: UIButton) {
              HKTools().toAppStore(vc: self)
    }
}
// MARK: Swith
extension HKSelectImageViewController {
    @IBAction func boxRandomSwithValueChange(_ sender: UISwitch) {
        rescoucceConfiguration.box_Random = sender.isOn
        change_H()
    }
    
    @IBAction func textSwitchValueChanged(_ sender: UISwitch) {
        textView_H.constant = sender.isOn ? 200 : 46
        rescoucceConfiguration.text_isShow = sender.isOn
        change_H()
    }
    @IBAction func particleSwitchValueChanged(_ sender: UISwitch) {
        particleView_H.constant = sender.isOn ? 100 : 46
        rescoucceConfiguration.particle_isShow = sender.isOn
        change_H()
    }
    func change_H() {
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension HKSelectImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var num = 0
        if collectionView == collectionView_Box {
            num = rescouceManager.boxImages.count
        } else if collectionView == collectionView_H {
            num = rescouceManager.horizontalImages.count
        } else if collectionView == collectionView_V {
            num = rescouceManager.verticalImages.count
        }
        return num
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier: String = ""
        var image: UIImage?
        if collectionView == collectionView_Box {
            identifier = identifier_Box
            image = rescouceManager.boxImages[indexPath.row]
        } else if collectionView == collectionView_H {
            identifier = identifier_H
            image = rescouceManager.horizontalImages[indexPath.row]
        } else if collectionView == collectionView_V {
            identifier = identifier_V
            image = rescouceManager.verticalImages[indexPath.row]
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HKImageCollectionViewCell
        cell.imageView.image = image
        if collectionView == collectionView_Box {
            cellShake(cell: cell, shake: box_Delete)
        } else if collectionView == collectionView_H {
            cellShake(cell: cell, shake: H_Delete)
        } else if collectionView == collectionView_V {
            cellShake(cell: cell, shake: V_Delete)
        }
        return cell
    }
}

// MARK: KeyBoard
extension HKSelectImageViewController {
    @objc func keyBoardWillShow(_ notification: Notification) {
        self.scrollView_Bottom.constant = 160
        let rect = CGRect(x: 0, y: scrollView.contentSize.height - 600, width: scrollView.contentSize.width, height: 667)
        self.scrollView.scrollRectToVisible(rect, animated: true)
    }
    @objc func keyBoardWillHide(_ notification: Notification) {
        self.scrollView_Bottom.constant = 60
    }
}

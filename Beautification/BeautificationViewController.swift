import UIKit
import CoreImage
import YUCIHighPassSkinSmoothing
import SnapKit

class DefaultRenderContextViewController: UIViewController {

    private let context = CIContext(options: [CIContextOption.workingColorSpace: CGColorSpaceCreateDeviceRGB()])
    private let filter = YUCIHighPassSkinSmoothing()
    
    private let imageView = UIImageView()
    private let amountSlider = UISlider()
    
    private var sourceImage: UIImage? {
        didSet {
            if let cgImage = sourceImage?.cgImage {
                inputCIImage = CIImage(cgImage: cgImage)
                processImage()
            }
        }
    }
    
    private var inputCIImage: CIImage?
    private var processedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        // Configurar imagem inicial
        sourceImage = UIImage(named: "SampleImage") // Substitua pelo nome da sua imagem padrão
    }
    
    private func setupUI() {
        // Configurar a imageView
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(view.snp.width)
        }
        
        // Configurar o slider
        amountSlider.minimumValue = 0
        amountSlider.maximumValue = 1
        amountSlider.value = 0.75 // Valor inicial padrão
        amountSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        view.addSubview(amountSlider)
        amountSlider.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Adicionar botão para selecionar imagem
        let selectImageButton = UIBarButtonItem(title: "Selecionar Imagem", style: .plain, target: self, action: #selector(selectImageTapped))
        navigationItem.rightBarButtonItem = selectImageButton
    }
    
    @objc private func sliderValueChanged() {
        processImage()
    }
    
    @objc private func selectImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

    private func processImage() {
        guard let inputImage = inputCIImage else { return }
        
        filter.inputImage = inputImage
        filter.inputAmount = NSNumber(value: amountSlider.value)
        filter.inputRadius = NSNumber(value: 7.0 * inputImage.extent.width / 750.0)
        
        guard let outputCIImage = filter.outputImage else { return }
        if let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
            processedImage = UIImage(cgImage: outputCGImage, scale: sourceImage?.scale ?? 1.0, orientation: sourceImage?.imageOrientation ?? .up)
            imageView.image = processedImage
        }
    }
}

extension DefaultRenderContextViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            sourceImage = image
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

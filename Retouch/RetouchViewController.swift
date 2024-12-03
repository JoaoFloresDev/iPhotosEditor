import UIKit
import CoreImage

class ImageEditorViewController: UIViewController, UIScrollViewDelegate {
    private var scrollView: UIScrollView!
    private var imageView: UIImageView!
    private var currentImage: UIImage! // A imagem que será editada
    private var ciContext = CIContext() // Contexto do Core Image
    private var brushRadius: CGFloat = 10.0 // Raio do pincel para retoque
    private var overlayLayer: CAShapeLayer! // Para desenhar o círculo de visualização

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }

    func setImage(_ image: UIImage) {
        currentImage = image
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Configuração do UIScrollView para permitir zoom e movimento
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)

        // Configuração do UIImageView
        imageView = UIImageView(frame: scrollView.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = currentImage
        scrollView.addSubview(imageView)

        // Adiciona UIPanGestureRecognizer para retoque com um dedo
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        imageView.addGestureRecognizer(panGesture)

        // Adiciona UIPanGestureRecognizer para mover a imagem com dois dedos
        let twoFingerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTwoFingerPanGesture(_:)))
        twoFingerPanGesture.minimumNumberOfTouches = 2
        imageView.addGestureRecognizer(twoFingerPanGesture)

        // Adiciona UITapGestureRecognizer para retoque ao clicar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        imageView.addGestureRecognizer(tapGesture)

        // Adiciona slider para ajustar o tamanho do pincel
        let slider = UISlider(frame: CGRect(x: 20, y: view.bounds.height - 60, width: view.bounds.width - 40, height: 40))
        slider.minimumValue = 5 // Valor mínimo reduzido
        slider.maximumValue = 100
        slider.value = Float(brushRadius)
        slider.addTarget(self, action: #selector(brushSizeChanged(_:)), for: .valueChanged)
        view.addSubview(slider)

        // Configuração da camada para o círculo de visualização
        overlayLayer = CAShapeLayer()
        overlayLayer.strokeColor = UIColor.red.cgColor
        overlayLayer.fillColor = UIColor.clear.cgColor
        overlayLayer.lineWidth = 2
        imageView.layer.addSublayer(overlayLayer)
    }

    private func setupNavigationBar() {
        title = "Editor de Imagem"
        
        // Botão de voltar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Voltar",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        // Botão para selecionar uma imagem
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(selectImage)
        )
    }

    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc private func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .changed || gesture.state == .ended else { return }

        let location = gesture.location(in: imageView)
        performRetouch(at: location)
    }

    @objc private func handleTwoFingerPanGesture(_ gesture: UIPanGestureRecognizer) {
        // Permite mover a imagem com dois dedos
        let translation = gesture.translation(in: scrollView)
        scrollView.contentOffset.x -= translation.x
        scrollView.contentOffset.y -= translation.y
        gesture.setTranslation(.zero, in: scrollView)
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: imageView)
        performRetouch(at: location)
    }

    @objc private func brushSizeChanged(_ sender: UISlider) {
        brushRadius = CGFloat(sender.value)
    }

    private func performRetouch(at location: CGPoint) {
        guard let tappedImage = currentImage else { return }

        // Converte a posição do toque para as coordenadas da imagem
        let imageCoordinates = convertToImageCoordinates(location: location, in: imageView, image: tappedImage)

        // Atualiza o círculo de visualização
        updateOverlay(at: location)

        // Aplica retoque na área selecionada
        if let updatedImage = applyBlur(at: imageCoordinates, to: tappedImage) {
            imageView.image = updatedImage
            currentImage = updatedImage
        }
    }

    private func convertToImageCoordinates(location: CGPoint, in imageView: UIImageView, image: UIImage) -> CGPoint {
        let imageSize = image.size
        let imageViewSize = imageView.bounds.size

        let scaleX = imageSize.width / imageViewSize.width
        let scaleY = imageSize.height / imageViewSize.height

        let scale = max(scaleX, scaleY)
        let offsetX = (imageViewSize.width - imageSize.width / scale) / 2
        let offsetY = (imageViewSize.height - imageSize.height / scale) / 2

        let x = (location.x - offsetX) * scale
        let y = (location.y - offsetY) * scale

        return CGPoint(x: x, y: y)
    }

    private func updateOverlay(at point: CGPoint) {
        let circlePath = UIBezierPath(
            arcCenter: point,
            radius: brushRadius,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
        overlayLayer.path = circlePath.cgPath
    }

    private func applyBlur(at point: CGPoint, to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }

        // Cria uma máscara radial para aplicar o blur
        guard let mask = CIFilter(name: "CIRadialGradient", parameters: [
            "inputCenter": CIVector(x: point.x, y: ciImage.extent.height - point.y),
            "inputRadius0": brushRadius / 2,
            "inputRadius1": brushRadius,
            "inputColor0": CIColor(red: 1, green: 1, blue: 1, alpha: 1),
            "inputColor1": CIColor(red: 0, green: 0, blue: 0, alpha: 0)
        ])?.outputImage else { return nil }

        // Aplica o blur na imagem original
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter.setValue(10.0, forKey: kCIInputRadiusKey)

        guard let blurredImage = blurFilter.outputImage else { return nil }

        // Combina a imagem borrada com a original usando a máscara
        guard let blendFilter = CIFilter(name: "CIBlendWithMask") else { return nil }
        blendFilter.setValue(blurredImage, forKey: kCIInputImageKey)
        blendFilter.setValue(ciImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(mask, forKey: kCIInputMaskImageKey)

        guard let outputImage = blendFilter.outputImage,
              let cgImage = ciContext.createCGImage(outputImage, from: ciImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }

    // Delegado para zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ImageEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[.originalImage] as? UIImage {
            setImage(selectedImage)
            imageView.image = currentImage
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

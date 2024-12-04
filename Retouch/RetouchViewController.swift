import UIKit
import CoreImage
import YUCIHighPassSkinSmoothing

class ImageEditorViewController: UIViewController, UIScrollViewDelegate {
    private var scrollView: UIScrollView!
    private var imageView: UIImageView!
    private var currentImage: UIImage! {
        didSet {
            if let cgImage = currentImage?.cgImage {
                inputCIImage = CIImage(cgImage: cgImage)
                processImage()
            }
        }
    }
    
    private let context = CIContext(options: [CIContextOption.workingColorSpace: CGColorSpaceCreateDeviceRGB()])
    private let filter = YUCIHighPassSkinSmoothing()
    private var inputCIImage: CIImage?
    private var processedImage: UIImage?
    
    private var ciContext = CIContext() // Contexto do Core Image
    private var brushRadius: CGFloat = 10.0 // Raio do pincel para retoque
    private var blurIntensity: CGFloat = 3.0 // Intensidade inicial do blur
    private var overlayLayer: CAShapeLayer! // Para desenhar o círculo de visualização

    private var historyStack: [UIImage] = [] // Pilha para armazenar o histórico de alterações

    private let amountSlider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        presentImagePicker() // Abre o picker assim que a tela é carregada
    }

    func setImage(_ image: UIImage) {
        currentImage = image
    }
    
    private func setupUI() {
        view.backgroundColor = .black

        // Configuração do UIScrollView para permitir zoom e movimento
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.backgroundColor = .black
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        view.addSubview(scrollView)

        // Calcula o frame da imagem para centralizá-la na parte superior
        let navigationBarHeight = navigationController?.navigationBar.frame.maxY ?? 0
        let availableHeight = view.bounds.height - navigationBarHeight
        let imageHeight = currentImage?.size.height ?? availableHeight
        let imageViewHeight = min(imageHeight, availableHeight * 0.75) // Mantém 75% da altura disponível

        // Configuração do UIImageView
        imageView = UIImageView(frame: CGRect(x: 0, y: navigationBarHeight - 20, width: view.bounds.width, height: imageViewHeight))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = currentImage
        scrollView.addSubview(imageView)

        // Adiciona UITapGestureRecognizer para retoque ao clicar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        imageView.addGestureRecognizer(tapGesture)

        // Adiciona UIPanGestureRecognizer para retoque com um dedo
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        imageView.addGestureRecognizer(panGesture)

        // Configuração da camada para o círculo de visualização
        overlayLayer = CAShapeLayer()
        overlayLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        overlayLayer.fillColor = UIColor.clear.cgColor
        overlayLayer.lineWidth = 2
        overlayLayer.isHidden = true // Começa oculto
        imageView.layer.addSublayer(overlayLayer)

        // Adiciona slider para ajustar o tamanho do pincel
        let brushSlider = createSlider(
            frame: CGRect(x: 20, y: view.bounds.height - 140, width: view.bounds.width - 40, height: 40),
            minValue: 5,
            maxValue: 100,
            initialValue: Float(brushRadius),
            action: #selector(brushSizeChanged(_:)),
            iconName: "dot.arrowtriangles.up.right.down.left.circle"
        )
        view.addSubview(brushSlider)
        
        // Adiciona slider para ajustar a intensidade do blur
        let intensitySlider = createSlider(
            frame: CGRect(x: 20, y: view.bounds.height - 100, width: view.bounds.width - 40, height: 40),
            minValue: 1,
            maxValue: 10,
            initialValue: Float(blurIntensity),
            action: #selector(blurIntensityChanged(_:)),
            iconName: "wand.and.rays"
        )
        view.addSubview(intensitySlider)
        
        amountSlider.minimumValue = 0
        amountSlider.maximumValue = 1
        amountSlider.value = 0 // Valor inicial padrão
        amountSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        let thumbImage = createThumbWithIcon(iconName: "face.dashed.fill", size: CGSize(width: 30, height: 30))
        amountSlider.setThumbImage(thumbImage, for: .normal)
        
        view.addSubview(amountSlider)
        amountSlider.snp.makeConstraints { make in
            make.top.equalTo(brushSlider.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    @objc private func sliderValueChanged() {
        processImage()
    }
    
    private func processImage() {
        guard let inputImage = inputCIImage else { return }
        
        filter.inputImage = inputImage
        filter.inputAmount = NSNumber(value: amountSlider.value)
        filter.inputRadius = NSNumber(value: 7.0 * inputImage.extent.width / 750.0)
        
        guard let outputCIImage = filter.outputImage else { return }
        if let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
            processedImage = UIImage(cgImage: outputCGImage, scale: currentImage?.scale ?? 1.0, orientation: currentImage?.imageOrientation ?? .up)
            imageView.image = processedImage
        }
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white

        // Botão de voltar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )

        // Botão para trocar a imagem sendo editada
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(selectImage)
        )

        // Botão para compartilhar a imagem
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up")?.withTintColor(.white, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(shareImage)
        )
        
        let undoIcon = UIImage(systemName: "arrow.uturn.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let undoButton = UIBarButtonItem(
            image: undoIcon,
            style: .plain,
            target: self,
            action: #selector(undoLastEdit)
        )
        
        navigationItem.rightBarButtonItems = [addButton, shareButton, undoButton]
    }
    
    @objc private func undoLastEdit() {
        guard !historyStack.isEmpty else { return }
        let lastImage = historyStack.removeLast()
        imageView.image = lastImage
    }

    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc private func selectImage() {
        presentImagePicker()
    }

    @objc private func shareImage() {
        guard let image = currentImage else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: imageView)

        switch gesture.state {
        case .began, .changed:
            overlayLayer.isHidden = false // Exibe o círculo
            updateOverlay(at: location)
            performRetouch(at: location)
        case .ended, .cancelled:
            overlayLayer.isHidden = true // Oculta o círculo
        default:
            break
        }
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: imageView)
        overlayLayer.isHidden = false // Exibe o círculo temporariamente
        updateOverlay(at: location)
        performRetouch(at: location)

        // Oculta o círculo após um intervalo
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.overlayLayer.isHidden = true
        }
    }

    @objc private func brushSizeChanged(_ sender: UISlider) {
        brushRadius = CGFloat(sender.value)
    }

    @objc private func blurIntensityChanged(_ sender: UISlider) {
        blurIntensity = CGFloat(sender.value)
    }

    private func performRetouch(at location: CGPoint) {
        guard let tappedImage = currentImage else { return }

        // Adiciona a imagem atual ao histórico antes de aplicar a alteração
        if let currentImage = imageView.image {
            historyStack.append(currentImage)
        }

        // Converte a posição do toque para as coordenadas da imagem
        let imageCoordinates = convertToImageCoordinates(location: location, in: imageView, image: tappedImage)

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
        blurFilter.setValue(blurIntensity, forKey: kCIInputRadiusKey)

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

    private func createSlider(frame: CGRect, minValue: Float, maxValue: Float, initialValue: Float, action: Selector, iconName: String) -> UISlider {
        let slider = UISlider(frame: frame)
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.value = initialValue
        slider.addTarget(self, action: action, for: .valueChanged)

        // Define o thumb customizado com o ícone
        let thumbImage = createThumbWithIcon(iconName: iconName, size: CGSize(width: 30, height: 30))
        slider.setThumbImage(thumbImage, for: .normal)

        return slider
    }

    private func createThumbWithIcon(iconName: String, size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let cgContext = context.cgContext
            cgContext.setFillColor(UIColor.white.cgColor)
            cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))

            if let icon = UIImage(systemName: iconName)?.withTintColor(.black, renderingMode: .alwaysOriginal) {
                let iconRect = CGRect(x: (size.width - 20) / 2, y: (size.height - 20) / 2, width: 20, height: 20)
                icon.draw(in: iconRect)
            }
        }
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

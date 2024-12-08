import UIKit
import SceneKit
import ARKit
import simd
import Photos
import StoreKit
import Foundation
import AVFoundation
import AVKit
import GoogleMobileAds
import SnapKit

class Bubble: SCNNode {
    
    override init() {
        super.init()
        let bubble = SCNPlane(width: 0.35, height: 0.35)
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "bubbleText")
        material.isDoubleSided = true
        material.writesToDepthBuffer = false
        material.blendMode = .screen
        bubble.materials = [material]
        self.geometry = bubble
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, GADInterstitialDelegate, PurchaseViewControllerDelegate {
    func purchased() {
        print("purchased")
    }
    
    var lastActionIsAddPhoto = false
    @IBAction func undo(_ sender: Any) {
        if lastActionIsAddPhoto {
            lastActionIsAddPhoto = false
            sceneView.scene.rootNode.childNodes.last?.removeFromParentNode()
        } else {
            vertBrush.removeLastStroke()
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    MARK: - Variables
    var timerTutotial: Timer!
    var imagePicker: UIImagePickerController!
    let vertBrush = VertBrush()
    var buttonDown = false
    var imageView: UIImage!
    var imageView2:UIImageView!
    var clearDrawingButton : UIButton!
    var toggleModeButton : UIButton!
    var recordButton : UIButton!
    
    var frameIdx = 0
    var splitLine = false
    var lineRadius : Float = 0.001
    
    var metalLayer: CAMetalLayer! = nil
    var hasSetupPipeline = false
    
    var videoRecorder : MetalVideoRecorder? = nil
    var tempVideoUrl : URL? = nil
    var recordingOrientation : UIInterfaceOrientationMask? = nil
    let pscope = PermissionScope()
    
    enum ColorMode : Int {
        case color
        case normal
        case rainbow
        case black
        case light
    }
    
    var currentColor : SCNVector3 = SCNVector3(100,0.5,100)
    var colorMode : ColorMode = .rainbow
    
    var avgPos : SCNVector3! = nil
    
    var interstitial: GADInterstitial!
    
    var index: Int = 0 {
        didSet {
            if index >= 0 && index < imageNames.count {
                if let newImage = UIImage(named: imageNames[index]) {
                    image = newImage
                }
            }
        }
    }
    
    var image: UIImage = UIImage() {
        didSet {
            sphere.firstMaterial?.diffuse.contents = image
        }
    }
    
    //    MARK: - IBOutlet
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var tutorialAsset: UIButton!
    @IBOutlet weak var tutorialImage: UIImageView!
    @IBOutlet weak var buyProButton: UIButton!
    
    func setProgress(_ progress:Double){
        print(progress)
        let mutablePath = CGMutablePath()
        mutablePath.addRect(CGRect(x: 0, y: 0, width: imageView2.frame.size.width, height: imageView2.frame.size.height*CGFloat(progress)))
        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.fillColor = UIColor.white.cgColor
        imageView2.layer.mask = mask
    }
    
    var bubblesLeft = 50
    let soapBubble = Bubble()
    
    func initAR(){
        imageView2 = UIImageView(frame: CGRect(x: 0, y: self.view.frame.size.height*0.5, width: self.view.frame.size.width, height: self.view.frame.size.height*0.5))
        imageView2.contentMode = .scaleAspectFit
        imageView2.alpha = 0.9
        setProgress(Double(bubblesLeft/20))
        self.sceneView.addSubview(imageView2)
    }
    
    func getNewPosition() -> (SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            return pos + SCNVector3(0,-0.07,0) + dir.normalized() * 0.5
        }
        return SCNVector3(0, 0, -1)
    }
    
    private func floatBetween(_ first: Float,  and second: Float) -> Float {
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
    
    func newBubble() {
        setProgress(Double(bubblesLeft) / 20.0)
        
        guard bubblesLeft > 0 else { return }
        bubblesLeft -= 1
        
        guard let frame = sceneView.session.currentFrame else { return }
        let dir = getCameraDirection(from: frame)
        let position = getNewPosition()
        let newBubble = createBubble(at: position)
        
        runBubbleActions(on: newBubble, with: dir)
        sceneView.scene.rootNode.addChildNode(newBubble)
    }
    
    private func getCameraDirection(from frame: ARFrame) -> SCNVector3 {
        let mat = SCNMatrix4(frame.camera.transform)
        return SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
    }
    
    private func createBubble(at position: SCNVector3) -> SCNNode {
        let newBubble = soapBubble.clone()
        newBubble.position = position
        newBubble.scale = SCNVector3(1, 1, 1) * floatBetween(0.6, and: 1)
        return newBubble
    }
    
    private func runBubbleActions(on bubble: SCNNode, with direction: SCNVector3) {
        let firstAction = SCNAction.move(by: direction.normalized() * 0.5 + SCNVector3(0, 0.15, 0), duration: 0.5)
        firstAction.timingMode = .easeOut
        
        let secondAction = SCNAction.move(by: direction + SCNVector3(floatBetween(-1.5, and: 1.5), floatBetween(0, and: 1.5), 0), duration: TimeInterval(floatBetween(8, and: 11)))
        secondAction.timingMode = .easeOut
        
        bubble.runAction(firstAction)
        bubble.runAction(secondAction) {
            bubble.runAction(SCNAction.fadeOut(duration: 0)) {
//                DispatchQueue.main.async {
//                    playSoftImpact()
//                }
                bubble.removeFromParentNode()
            }
        }
    }
    
    let expandableView = ExpandableView()
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
//        pscope.addPermission(CameraPermission(), message: "\r相机是通往AR世界的钥匙")
        initAR()
        setupAds()
        setupSceneView()
        setupGestures()
        requestPhotoLibraryAuthorization()
        
        expandableView.delegate = self
        view.addSubview(expandableView)
        expandableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
    }
    
    let imageNames: [String] = [
        "", "panorama_0", "panorama_1", "panorama_2", "panorama_3",
        "panorama_4", "panorama_5", "panorama_6", "panorama_7",
        "panorama_8", "panorama_9", "panorama_10", "panorama_11", "panorama_12"
    ]
    let sphere = SCNSphere(radius: 10)
    var sphereIndex = 0
    var sphereNode: SCNNode?
    
    private func setupSphere() {
        if let existingSphereNode = sphereNode {
            existingSphereNode.removeFromParentNode()
        }

        sphereIndex += 1
        if sphereIndex >= imageNames.count {
            sphereIndex = 0
            sphere.firstMaterial?.diffuse.contents = nil
            return
        }

        let newSphereNode = SCNNode(geometry: sphere)
        sphere.firstMaterial?.isDoubleSided = true
        if let firstImage = UIImage(named: imageNames[sphereIndex]) {
            sphere.firstMaterial?.diffuse.contents = firstImage
        }
        newSphereNode.position = SCNVector3Zero
        sceneView.scene.rootNode.addChildNode(newSphereNode)
        
        sphereNode = newSphereNode
    }
    
    private func setupAds() {
        if UserDefaults.standard.object(forKey: "NoAds.DIA") != nil {
            buyProButton.isHidden = true
        } else {
            setupInterstitialAd()
        }
    }
    
    private func setupInterstitialAd() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/3254547941")
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["bc9b21ec199465e69782ace1e97f5b79"]
    }
    
    private func setupSceneView() {
        sceneView.delegate = self
        let scene = SCNScene(named: "art.scnassets/world.scn")!
        sceneView.scene = scene
        metalLayer = sceneView.layer as? CAMetalLayer
        metalLayer.framebufferOnly = false
    }
    
    private func setupGestures() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0
        tap.cancelsTouchesInView = false
        tap.delegate = self
        sceneView.addGestureRecognizer(tap)
    }
    
    private func requestPhotoLibraryAuthorization() {
        PHPhotoLibrary.requestAuthorization { status in
            print(status)
        }
    }
    
//    func rateApp() {
//        if #available(iOS 10.3, *) {
//            SKStoreReviewController.requestReview()
//        }
//    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let orientation = recordingOrientation {
            return orientation
        } else {
            return .all
        }
    }
    
    //    MARK: - GESTURES
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    var touchLocation : CGPoint = .zero
    
    // called by gesture recognizer
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            
            self.touchLocation = self.sceneView.center
            buttonTouchDown()
            
        } else if gesture.state == .ended {
            
            buttonTouchUp()
            
        } else if gesture.state == .changed {
            
            if buttonDown {
                self.touchLocation = gesture.location(in: self.sceneView)
            }
        }
    }
    
    @objc func buttonTouchDown() {
        splitLine = true
        buttonDown = true
        avgPos = nil
    }
    
    @objc func buttonTouchUp() {
        buttonDown = false
    }
    
    //    MARK: - LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBAction
    @IBAction func clearAll(_ sender: Any) {
        AudioServicesPlaySystemSound(1522)
        AudioServicesPlaySystemSound(1520)
        vertBrush.clear()
        
        for x in sceneView.scene.rootNode.childNodes {
            x.removeFromParentNode()
        }
        
        if(UserDefaults.standard.object(forKey: "NoAds.DIA") == nil) {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            }
        }
    }
    
    @IBAction func openPro(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Purchase",bundle: nil)
        let changePasswordCalcMode = storyboard.instantiateViewController(withIdentifier: "Purchase")
        if let changePasswordCalcMode = changePasswordCalcMode as? PurchaseViewController {
                changePasswordCalcMode.delegate = self
        }
        present(changePasswordCalcMode, animated: true)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8858389345934911/3254547941")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }

    @IBAction func tutorial(_ sender: Any) {
        timerTutotial.invalidate()
        tutorialAsset.removeFromSuperview()
        tutorialImage.removeFromSuperview()
        let tutu = UIImage(named: "tutu")
        self.plotImage (image: tutu!, size: 1, cornerRadius: 0)
    }
    
    //    MARK: - PLOT IMAGE FUNCTIONS
    func openGalery() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView = originalImage
        } else if let videoURL = info[.mediaURL] as? NSURL {
            addTV(url: videoURL)
        }
        
        picker.dismiss(animated: true, completion: nil)
        showMenu()
        lastActionIsAddPhoto = true
    }
    
    func plotImage(image: UIImage, size: CGFloat, cornerRadius: CGFloat) {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        
        let imagePlane = createImagePlane(from: image, with: size, and: cornerRadius)
        let planeNode = SCNNode(geometry: imagePlane)
        
        let transform = calculateTransform(for: currentFrame, with: image.imageOrientation, and: imagePlane)
        planeNode.simdTransform = transform
        
        sceneView.scene.rootNode.addChildNode(planeNode)
    }
    
    private func createImagePlane(from image: UIImage, with size: CGFloat, and cornerRadius: CGFloat) -> SCNPlane {
        var imagePlane = SCNPlane(width: image.size.width * size / 4000, height: image.size.height * size / 4000)
        
        if image.imageOrientation == .right || image.imageOrientation == .left {
            imagePlane = SCNPlane(width: image.size.height * size / 4000, height: image.size.width * size / 4000)
        }
        
        imagePlane.firstMaterial?.diffuse.contents = image
        imagePlane.firstMaterial?.lightingModel = .constant
        imagePlane.firstMaterial?.isDoubleSided = true
        imagePlane.cornerRadius = CGFloat(image.size.height * size / 100000 * cornerRadius)
        
        return imagePlane
    }
    
    private func calculateTransform(for currentFrame: ARFrame, with orientation: UIImage.Orientation, and imagePlane: SCNPlane) -> float4x4 {
        var angle: Float = 90
        
        switch orientation {
        case .right, .left:
            angle = 0
        case .down:
            print("down")
        default:
            print("default")
        }
        
        var translation = SCNMatrix4Translate(SCNMatrix4Identity, 0, 0, -1)
        translation = SCNMatrix4Rotate(translation, GLKMathDegreesToRadians(angle), 0, 0, 1)
        
        var transform = float4x4(translation)
        transform = matrix_multiply(currentFrame.camera.transform, transform)
        
        return transform
    }
    
    func addTV(url: NSURL) {
        let video = AVPlayer(url: url as URL)
        loopVideo(videoPlayer: video)
        
        var scene = SCNScene(named: "art.scnassets/VerticalTV.scn")!
        
        if let sizeVideo = resolutionSizeForLocalVideo(url: url) {
            if(sizeVideo.height < sizeVideo.width) {
                scene = SCNScene(named: "art.scnassets/tv.scn")!
            }
        }
        
        let tvNode = scene.rootNode.childNode(withName: "tv_node", recursively: true)
        let tvScreenPlaneNode = tvNode?.childNode(withName: "screen", recursively: true)
        
        let tvScreenPlaneNodeGeometry = tvScreenPlaneNode?.geometry as! SCNPlane
        let tvVideoNode = SKVideoNode(avPlayer: video)
        let videoScene = SKScene(size: .init(width: tvScreenPlaneNodeGeometry.width*1000, height: tvScreenPlaneNodeGeometry.height*1000))
        videoScene.addChild(tvVideoNode)
        tvVideoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
        tvVideoNode.size = videoScene.size
        let tvScreenMaterial = tvScreenPlaneNodeGeometry.materials.first(where: { $0.name == "video" })
        tvScreenMaterial?.diffuse.contents = videoScene
        
        tvNode?.position = self.sceneView.pointOfView?.position as! SCNVector3
        tvNode?.eulerAngles.y = self.sceneView.pointOfView?.eulerAngles.y as! Float + 180
        tvVideoNode.play()
        self.sceneView.scene.rootNode.addChildNode(tvNode!)
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    func resolutionSizeForLocalVideo(url:NSURL) -> CGSize? {
        guard let track = AVAsset(url: url as URL).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: fabs(size.width), height: fabs(size.height))
    }
    
    func cropBounds(viewlayer: CALayer, cornerRadius: Float) {
        let imageLayer = viewlayer
        imageLayer.cornerRadius = CGFloat(cornerRadius)
        imageLayer.masksToBounds = true
    }
    
    func showMenu() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        func addAction(title: String, size: CGFloat, handler: @escaping () -> Void) {
            let action = UIAlertAction(title: title, style: .default) { _ in
                self.plotImage(image: self.imageView, size: size, cornerRadius: 1)
            }
            optionMenu.addAction(action)
        }
        
        addAction(title: "x 1", size: 1) {}
        addAction(title: "x 5", size: 4) {}
        addAction(title: "x 10", size: 4) {}
        addAction(title: "x 15", size: 12) {}
        
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("cancel action")
        })
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    
    //    MARK: - EXPORT VIDEO AND IMAGES FUNCTIONS
    func exportRecordedVideo() {
        guard let videoUrl = self.tempVideoUrl else { return }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
        }) { saved, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if !saved {
                    let alertController = UIAlertController(title: "Error saving video", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let activityViewController = UIActivityViewController(activityItems: [videoUrl], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func catchVideo() {
        if let rec = self.videoRecorder, rec.isRecording {
            endRecording()
        } else {
            startRecording()
        }
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        
        // Definindo o layout com SnapKit
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return indicator
    }()
    
    private func endRecording() {
        // Mostra o indicador de carregamento
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }

        videoRecorder?.endRecording {
            AudioServicesPlaySystemSound(1518)
            
            DispatchQueue.main.async {
                // Exporta o vídeo gravado
                self.exportRecordedVideo()                

                // Reseta a orientação de gravação
                self.recordingOrientation = nil
            }
        }
    }
    
    private func startRecording() {
        let videoOutUrl = URL.documentsDirectory().appendingPathComponent("iPhotos.mp4")
        removeExistingFile(at: videoOutUrl)
        
        let size = self.metalLayer.drawableSize
        AudioServicesPlaySystemSound(1520)
        
        guard let rec = MetalVideoRecorder(outputURL: videoOutUrl, size: size, watermark: UIImage(named: "landscapeIcon-water")) else {
            print("Erro ao inicializar MetalVideoRecorder")
            return
        }
        
        rec.startRecording()
        
        self.videoRecorder = rec
        self.tempVideoUrl = videoOutUrl
        self.recordingOrientation = currentOrientationMask()
    }
    
    private func updateButtonImage(sender: Any, imageName: String) {
        if let button = sender as? UIButton {
            button.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    private func removeExistingFile(at url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("Erro ao remover arquivo existente: \(error)")
            }
        }
    }
    
    private func currentOrientationMask() -> UIInterfaceOrientationMask {
        // Retorna a orientação atual do dispositivo
        switch UIDevice.current.orientation {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    func addBall( _ pos : SCNVector3 ) -> SCNNode{
        let b = SCNSphere(radius: 0.01)
        b.firstMaterial?.diffuse.contents = UIColor.red
        let n = SCNNode(geometry: b)
        n.worldPosition = pos
        self.sceneView.scene.rootNode.addChildNode(n)
        return n
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let pointer = getPointerPosition()
        
        avgPos = avgPos ?? pointer.pos
        avgPos = avgPos! - (avgPos! - pointer.pos) * 0.4
        
        guard buttonDown, pointer.valid else { return }
        
        if vertBrush.points.isEmpty || (vertBrush.points.last! - pointer.pos).length() > 0.001 {
            updateLineRadius()
            let color = determineColor()
            
            vertBrush.addPoint(avgPos!,
                               radius: lineRadius,
                               color: color,
                               splitLine: splitLine)
            
            if splitLine {
                splitLine = false
            }
        }
        
        frameIdx += 1
    }
    
    private func updateLineRadius() {
        var radius: Float = 0.001
        
        if !splitLine, vertBrush.points.count >= 2 {
            let i = vertBrush.points.count - 1
            let p1 = vertBrush.points[i]
            let p2 = vertBrush.points[i - 1]
            radius = 0.001 + min(0.015, 0.005 * pow((p2 - p1).length() / 0.005, 2))
        }
        
        lineRadius = lineRadius - (lineRadius - radius) * 0.075
    }
    
    private func determineColor() -> SCNVector3 {
        switch colorMode {
        case .rainbow:
            return colorForRainbowMode()
        case .normal:
            return SCNVector3(-1, -1, -1)
        case .light:
            return colorForLightMode()
        case .color:
            return colorForColorMode()
        case .black:
            return SCNVector3(0.1, 0.1, 0.1)
        }
    }
    
    private func colorForRainbowMode() -> SCNVector3 {
        let hue: CGFloat = CGFloat(fmodf(Float(vertBrush.points.count) / 30.0, 1.0))
        let color = UIColor(hue: hue, saturation: 0.95, brightness: 1, alpha: 1.0)
        return color.toSCNVector3()
    }
    
    private func colorForLightMode() -> SCNVector3 {
        lastActionIsAddPhoto = true
        lineRadius = 0
        let hue: CGFloat = CGFloat(fmodf(10, 0.5))
        let color = UIColor(hue: hue, saturation: 0.5, brightness: 10, alpha: 0.8)
        
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.white
        
        let node = SCNNode(geometry: sphere)
        node.worldPosition = avgPos!
        sceneView.scene.rootNode.addChildNode(node)
        
        addGlowTechnique(node: node, sceneView: sceneView)
        configureGlowTechnique()
        
        return color.toSCNVector3()
    }
    
    private func colorForColorMode() -> SCNVector3 {
        lineRadius = 0.003
        let hue: CGFloat = CGFloat(fmodf(100, 10))
        let color = UIColor(hue: hue, saturation: 10, brightness: 0.5, alpha: 0.8)
        return color.toSCNVector3()
    }
    
    private func configureGlowTechnique() {
        if let path = Bundle.main.path(forResource: "NodeTechnique", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            let technique = SCNTechnique(dictionary: dict)
            let glowColor = SCNVector3(1.0, 1.0, 0.0)
            technique?.setValue(NSValue(scnVector3: glowColor), forKeyPath: "glowColorSymbol")
            sceneView.technique = technique
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        setupPipelineIfNeeded()
        guard let frame = self.sceneView.session.currentFrame else { return }
        renderScene(frame: frame)
        recordVideoFrame()
    }
    
    private func setupPipelineIfNeeded() {
        guard !hasSetupPipeline else { return }
        hasSetupPipeline = true
        vertBrush.setupPipeline(device: sceneView.device!, renderDestination: self.sceneView!)
    }
    
    private func renderScene(frame: ARFrame) {
        guard let commandQueue = self.sceneView?.commandQueue,
              let encoder = self.sceneView.currentRenderCommandEncoder else { return }
        
        let projMat = float4x4((self.sceneView.pointOfView?.camera?.projectionTransform)!)
        let modelViewMat = float4x4((self.sceneView.pointOfView?.worldTransform)!).inverse
        
        vertBrush.updateSharedUniforms(frame: frame)
        vertBrush.render(commandQueue, encoder, parentModelViewMatrix: modelViewMat, projectionMatrix: projMat)
    }
    
    private func recordVideoFrame() {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let recorder = self.videoRecorder, recorder.isRecording,
                  let tex = self.metalLayer.nextDrawable()?.texture else { return }
            recorder.writeFrame(forTexture: tex)
        }
    }
    
    // MARK: -
    func getPointerPosition() -> (pos : SCNVector3, valid: Bool, camPos : SCNVector3 ) {
        
        guard let pointOfView = sceneView.pointOfView else { return (SCNVector3Zero, false, SCNVector3Zero) }
        guard let currentFrame = sceneView.session.currentFrame else { return (SCNVector3Zero, false, SCNVector3Zero) }
        
        let cameraPos = SCNVector3(currentFrame.camera.transform.translation)
        
        let touchLocationVec = SCNVector3(x: Float(touchLocation.x), y: Float(touchLocation.y), z: 0.01)
        
        let screenPosOnFarClippingPlane = self.sceneView.unprojectPoint(touchLocationVec)
        
        let dir = (screenPosOnFarClippingPlane - cameraPos).normalized()
        
        let worldTouchPos = cameraPos + dir * 0.12
        
        return (worldTouchPos, true, pointOfView.position)
    }
    
    //    MARK: - Alerts
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
                                                    message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
}

extension ViewController {
    public func addGlowTechnique(node:SCNNode ,sceneView:ARSCNView){
        node.categoryBitMask = 2;
        if let path = Bundle.main.path(forResource: "NodeTechnique", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path)  {
                let dict2 = dict as! [String : AnyObject]
                let technique = SCNTechnique(dictionary:dict2)
                sceneView.technique = technique
            }
        }
    }
}

extension UIColor {
    func toSCNVector3() -> SCNVector3 {
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        // Garanta que os valores estão no intervalo correto
        red = max(0.0, min(1.0, red))
        green = max(0.0, min(1.0, green))
        blue = max(0.0, min(1.0, blue))
        
        return SCNVector3(Float(red), Float(green), Float(blue))
    }
}

extension URL {
    static func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

extension String {
    func format(_ args: CVarArg...) -> String {
        return NSString(format: self, arguments: getVaList(args)) as String
    }
}

extension ViewController: ExpandableViewDelegate {
    
    func didSelect(item: ButtonActions) {
        switch item {
        case .changeColor:
            AudioServicesPlaySystemSound(SystemSoundID(1104))
            AudioServicesPlaySystemSound(SystemSoundID(1520))
            self.colorMode = ColorMode(rawValue: (self.colorMode.rawValue + 1) % 5)!
            
            switch self.colorMode {
            case .rainbow:
                expandableView.setChangeColorButtonImage(named: "color1.png")
                
            case .normal:
                expandableView.setChangeColorButtonImage(named: "color2.png")
                
            case .color:
                expandableView.setChangeColorButtonImage(named: "redColor.png")
                
            case .black:
                expandableView.setChangeColorButtonImage(named: "blackColor.png")
                
            case .light:
                expandableView.setChangeColorButtonImage(named: "yellowLight.png")
            }
            
        case .record:
            if let rec = self.videoRecorder {
                let imageName = rec.isRecording ? "gravar.png" : "gravando.png"
                expandableView.setChangeRecordButtonImage(named: imageName)
            } else {
                expandableView.setChangeRecordButtonImage(named: "gravando.png")
            }
            catchVideo()
            
        case .addImage:
            AudioServicesPlaySystemSound(SystemSoundID(1520))
            AudioServicesPlaySystemSound(SystemSoundID(1103))
            openGalery()
            
        case .location:
            setupSphere()
            
        case .bubbles:
            newBubble()
            
        case .photoStorm:
            let manager = RescouceManager.share
            if manager.boxImages.count == 0 {
                manager.addBoxImage(image: UIImage(named: "B_Image_0")!)
                manager.addBoxImage(image: UIImage(named: "B_Image_1")!)
                manager.addBoxImage(image: UIImage(named: "B_Image_2")!)
                manager.addBoxImage(image: UIImage(named: "B_Image_3")!)
                manager.addBoxImage(image: UIImage(named: "B_Image_4")!)
            }
            if manager.verticalImages.count == 0 {
                manager.addVerticalImage(image: UIImage(named: "V_Image_0")!)
                manager.addVerticalImage(image: UIImage(named: "V_Image_1")!)
                manager.addVerticalImage(image: UIImage(named: "V_Image_2")!)
                manager.addVerticalImage(image: UIImage(named: "V_Image_3")!)
                manager.addVerticalImage(image: UIImage(named: "V_Image_4")!)
                manager.addVerticalImage(image: UIImage(named: "V_Image_5")!)
            }
            if manager.horizontalImages.count == 0 {
                manager.addHorizontalImage(image: UIImage(named: "H_Image_0")!)
                manager.addHorizontalImage(image: UIImage(named: "H_Image_1")!)
                manager.addHorizontalImage(image: UIImage(named: "H_Image_2")!)
                manager.addHorizontalImage(image: UIImage(named: "H_Image_3")!)
                manager.addHorizontalImage(image: UIImage(named: "H_Image_4")!)
                manager.addHorizontalImage(image: UIImage(named: "H_Image_5")!)
                manager.addHorizontalImage(image: UIImage(named: "H_Image_6")!)
            }
            if manager.text == nil {
                if  manager.text?.count == 0 {
                    manager.text = "嗨,你好呀!"
                    manager.textColor = "textColor_0"
                }
            }
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "HKMemoirsViewController")
            let navigation = UINavigationController(rootViewController: vc)
            self.present(navigation, animated: true)
//            pscope.show({ _, _ in
//                self.pscope.hide()
//                let videoAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
//                switch videoAuthStatus {
//                case .notDetermined: break
//                case .denied: break
//                default:
//                    let sb = UIStoryboard.init(name: "Main", bundle: nil)
//                    let vc = sb.instantiateViewController(withIdentifier: "HKMemoirsViewController")
//                    let navigation = UINavigationController(rootViewController: vc)
//                    self.present(navigation, animated: true)
//                }
//            }, cancelled: { _ in
//                print("thing was cancelled")
//                self.pscope.hide()
//            }
//            )
        }
    }
}

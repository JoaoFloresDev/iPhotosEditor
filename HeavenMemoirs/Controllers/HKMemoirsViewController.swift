import UIKit
import SceneKit
import ARKit
import ReplayKit
import AssetsLibrary
import Photos

class HKMemoirsViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: HKARSCNView!
    // MARK: Button
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet var smailButtons: [UIButton]!
    
    var selectNode: SCNNode?
    
    var documentController: UIDocumentInteractionController?
    let replayVideoFileName: String = "REPLAY_WEARE.MP4"

    let rescouceManager = RescouceManager.share
    let rescoucceConfiguration = RescouceConfiguration.share

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        showPhotos()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        //抗锯齿
        sceneView.antialiasingMode = .multisampling4X
        showPhotos()
        perform(#selector(hidenPreview), with: nil, afterDelay: 3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle(gesture:)))
        sceneView.addGestureRecognizer(tap)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// UI+动画
extension HKMemoirsViewController {
    func showPhotos() {
        sceneView.removeAllNodes()
        sceneView.addPhotoRing_Box(vector3: SCNVector3Make(0, 0, -6), left: 1, L: 40)
        sceneView.addPhotoRing_H(vector3: SCNVector3Make(0, -1.2, -6), left: -1, L: 10)
        sceneView.addPhotoRing_Box(vector3: SCNVector3Make(0, -2.4, -6), left: 1, L: 40)
        sceneView.addPhotoRing_V(vector3: SCNVector3Make(0, 1.5, -6), left: 1, L: 20)
        sceneView.addPhotoRing_V(vector3: SCNVector3Make(0, -4, -6), left: -1, L: 20)
        sceneView.addPhotoRing_Back(vector3: SCNVector3Make(0, -2, -8), left: -1, L: 2)
        //背景
        if rescoucceConfiguration.panorama_isShow {
            if let panoramaImage = rescouceManager.panoramaImage {
                sceneView.addPanoramaImage(image: panoramaImage)
            }
        }
        //播放视频
        if rescoucceConfiguration.video_isPlay {
            if let url = rescouceManager.videoURL {
                sceneView.playVideo(url: url)
            }
        }
        //播放背景音乐
        if rescoucceConfiguration.voice_isPlay {
            if let musicName = rescouceManager.musicName {
                sceneView.playMusic(musicName: musicName)
            }
        }
        //粒子效果
        if rescoucceConfiguration.particle_isShow {
            sceneView.addParticleSytem(type: rescouceManager.particleType)
        }
        //文字
        if rescoucceConfiguration.text_isShow {
            if let text = rescouceManager.text {
                if let color = rescouceManager.textColor {
                    sceneView.addPhotoRing_Text(text: text, color: color)
                }
            }
        }
    }

    @objc func hidenPreview() {
        UIView.animate(withDuration: 1.2) {
            self.view.layoutIfNeeded()
        }
    }
}
//点击到的节点
extension HKMemoirsViewController {
    @objc func tapHandle(gesture: UITapGestureRecognizer) {
        let results: [SCNHitTestResult] = (self.sceneView?.hitTest(gesture.location(ofTouch: 0, in: self.sceneView), options: nil))!
        guard let firstNode  = results.first else {
            return
        }
        // 点击到的节点
        let node = firstNode.node.copy() as? SCNNode

        if (node?.geometry?.isKind(of: SCNSphere.self))! {
            self.selectNode?.removeFromParentNode()
            return
        }

        if firstNode.node == self.selectNode {
            let newPosition  = SCNVector3Make(firstNode.node.worldPosition.x*2, firstNode.node.worldPosition.y*2, firstNode.node.worldPosition.z*2)
            let comeOut = SCNAction.move(to: newPosition, duration: 1.2)
            firstNode.node.runAction(comeOut)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2, execute: {
                firstNode.node.removeFromParentNode()
            })
        } else {
            self.selectNode?.removeFromParentNode()
            node?.position = firstNode.node.worldPosition
            let newPosition  = SCNVector3Make(firstNode.node.worldPosition.x/2, firstNode.node.worldPosition.y/2, firstNode.node.worldPosition.z/2)
            node?.rotation = (sceneView.pointOfView?.rotation)!
            sceneView.scene.rootNode.addChildNode(node!)
            let comeOn = SCNAction.move(to: newPosition, duration: 1.2)
            node?.runAction(comeOn)
            selectNode = node
        }
    }
}
// MARK: 按钮点击事件
extension HKMemoirsViewController {
    @IBAction func mainButtonDidClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onlyPanoramaButtonDidClick(_ sender: UIButton) {
        // remove all photos or present
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sceneView.removeAllNodes()
            if rescoucceConfiguration.panorama_isShow {
                if let panoramaImage = rescouceManager.panoramaImage {
                    sceneView.addPanoramaImage(image: panoramaImage)
                }
            }
        } else {
            showPhotos()
        }
    }
}

// MARK: ReplayKit
extension HKMemoirsViewController: RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        if activityTypes.count == 0 {
            previewController.dismiss(animated: true, completion: nil)
        }
        
        if activityTypes.contains("com.apple.UIKit.activity.SaveToCameraRoll") {
            previewController.dismiss(animated: true, completion: nil)
            //检测到您刚刚保存了视频 是否想要分享
            let delay = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.outputVideo()
            }
        }
    }
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        print(previewController)
    }
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        if error != nil {
            DispatchQueue.main.async {
                let string = error?.localizedDescription
                self.showFailReplay()
            }
        }
    }
    //录制失败
    func showFailReplay() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HKExplainViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
        for button in self.smailButtons {
            button.alpha = 1
        }
        self.mainButton.alpha = 1
        UIView.animate(withDuration: 2.5) {
            self.view.layoutIfNeeded()
        }
    }
    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print(screenRecorder)
    }
    // MARK: 提取视频
    func outputVideo() {
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        for i in 0..<smartAlbums.count {
            let assetCollection = smartAlbums[i]
            let assetsFetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: assetCollection, options: nil)
            if assetCollection.localizedTitle == "视频" {
                if assetsFetchResult.count > 0 {
                    let phAsset: PHAsset = assetsFetchResult.lastObject!
                    _ = PHVideoRequestOptions()

                    let assetResources = PHAssetResource.assetResources(for: phAsset)
                    var resource: PHAssetResource?

                    for assetRes in assetResources {
                        resource = assetRes
                    }
                    let PATH_MOVIE_FILE = NSTemporaryDirectory().appending(replayVideoFileName)
                    try? FileManager.default.removeItem(atPath: PATH_MOVIE_FILE)
                    PHAssetResourceManager.default().writeData(for: resource!, toFile: URL.init(fileURLWithPath: PATH_MOVIE_FILE), options: nil, completionHandler: { (error) in
                        if error != nil {
                        } else {
                            DispatchQueue.main.async {
                                self.showShareAlert()
                            }
                        }
                    })
                }
            }
        }
    }
}

// MARK: Share
extension HKMemoirsViewController {
    func showShareAlert() {
        let alertVc = UIAlertController.init(title: "", message: "分享视频", preferredStyle: .alert)
        let alertAction0 = UIAlertAction.init(title: "分享", style: .default) { (_) in
            self.share()
        }
        let alertAction1 = UIAlertAction.init(title: "取消", style: .cancel) { (_) in
        }
        alertVc.addAction(alertAction0)
        alertVc.addAction(alertAction1)
        self.present(alertVc, animated: true, completion: nil)
    }
    func share() {
        let PATH_MOVIE_FILE = NSTemporaryDirectory().appending("REPLAY_WEARE.MP4")
        let url = URL.init(fileURLWithPath: PATH_MOVIE_FILE)
        self.documentController = UIDocumentInteractionController(url: url)
        let vc = UIApplication.shared.keyWindow?.rootViewController
        self.documentController?.presentOpenInMenu(from: UIScreen.main.bounds, in: vc!.view, animated: true)
        self.documentController?.delegate = self
    }
}

extension HKMemoirsViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        let PATH_MOVIE_FILE = NSTemporaryDirectory().appending(replayVideoFileName)
        try? FileManager.default.removeItem(atPath: PATH_MOVIE_FILE)
    }
}

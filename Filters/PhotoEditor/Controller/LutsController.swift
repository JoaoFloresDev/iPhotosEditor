import Foundation
import Combine
import SwiftUI
import PixelEnginePackage
import CoreData

class LutsController: ObservableObject {
    
    @Published var loadingLut: Bool = false
    var collections: [Collection] = []
    var cubeSourceCG: CGImage?
    
    @Published var currentCube: String = ""
    @Published var editingLut: Bool = false
    
    var showLoading: Bool {
        return loadingLut || cubeSourceCG == nil
    }
    
    func setImage(image: CIImage) {
        currentCube = ""
        cubeSourceCG = nil
        loadingLut = true
        collections = Data123.shared.collections
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("init Cube")
            
            // Verifica se a imagem CGImage foi criada com sucesso
            guard let cubeImage = sharedContext.createCGImage(image, from: image.extent) else {
                DispatchQueue.main.async {
                    self.loadingLut = false
                }
                return
            }
            
            self.cubeSourceCG = cubeImage
            
            for collection in self.collections {
                collection.setImage(image: image)
            }
            
            DispatchQueue.main.async {
                self.loadingLut = false
            }
        }
    }
    
    func selectCube(_ value: String) {
        currentCube = value
    }
    
    func onSetEditingMode(_ value: Bool) {
        editingLut = value
    }
}

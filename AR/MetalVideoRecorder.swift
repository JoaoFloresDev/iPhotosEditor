import Foundation
import AVFoundation
import Foundation
import AVFoundation
import MetalKit

import Foundation
import AVFoundation
import MetalKit
import UIKit

class MetalVideoRecorder {
    var isRecording = false
    var recordingStartTime = TimeInterval(0)
    var watermarkImage: UIImage?
    
    private var assetWriter: AVAssetWriter
    private var assetWriterVideoInput: AVAssetWriterInput
    private var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor
    private let ciContext: CIContext
    private let recordingQueue = DispatchQueue(label: "MetalVideoRecorderQueue")
    
    init?(outputURL url: URL, size: CGSize, watermark: UIImage?) {
        do {
            assetWriter = try AVAssetWriter(outputURL: url, fileType: .mp4)
        } catch {
            print("Erro ao criar AVAssetWriter: \(error)")
            return nil
        }
        
        self.watermarkImage = watermark
        
        // Configurações de saída de vídeo
        let outputSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 6000000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
            ]
        ]
        
        assetWriterVideoInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
        assetWriterVideoInput.expectsMediaDataInRealTime = true
        
        let sourcePixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String: Int(size.width),
            kCVPixelBufferHeightKey as String: Int(size.height),
            kCVPixelFormatOpenGLESCompatibility as String: true
        ]
        
        assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: assetWriterVideoInput,
            sourcePixelBufferAttributes: sourcePixelBufferAttributes
        )
        
        if assetWriter.canAdd(assetWriterVideoInput) {
            assetWriter.add(assetWriterVideoInput)
        } else {
            print("Erro: Não foi possível adicionar o assetWriterVideoInput.")
            return nil
        }
        
        // Inicializa o contexto do Core Image
        let options = [CIContextOption.workingColorSpace: CGColorSpaceCreateDeviceRGB()]
        ciContext = CIContext(options: options)
    }
    
    func startRecording() {
        recordingQueue.async {
            guard self.assetWriter.status == .unknown else {
                print("AVAssetWriter já foi iniciado ou não está no estado 'unknown'.")
                return
            }
            
            self.assetWriter.startWriting()
            self.assetWriter.startSession(atSourceTime: CMTime.zero)
            self.recordingStartTime = CACurrentMediaTime()
            self.isRecording = true
            print("Gravação iniciada")
        }
    }
    
    func endRecording(completionHandler: @escaping () -> Void) {
        recordingQueue.async {
            guard self.assetWriter.status == .writing else {
                print("Erro: Não é possível finalizar a gravação, status atual: \(self.assetWriter.status.rawValue)")
                if let error = self.assetWriter.error {
                    print("Erro do AVAssetWriter: \(error.localizedDescription)")
                }
                return
            }
            
            self.isRecording = false
            self.assetWriterVideoInput.markAsFinished()
            
            self.assetWriter.finishWriting {
                DispatchQueue.main.async {
                    if self.assetWriter.status == .completed {
                        print("Gravação finalizada com sucesso")
                    } else {
                        print("Erro ao finalizar a gravação: \(self.assetWriter.error?.localizedDescription ?? "Erro desconhecido")")
                    }
                    completionHandler()
                }
            }
        }
    }
    
    func writeFrame(forTexture texture: MTLTexture) {
        recordingQueue.async {
            autoreleasepool {
                guard self.isRecording,
                      self.assetWriterVideoInput.isReadyForMoreMediaData,
                      let pixelBufferPool = self.assetWriterPixelBufferInput.pixelBufferPool else { return }
                
                var maybePixelBuffer: CVPixelBuffer? = nil
                let status = CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool, &maybePixelBuffer)
                guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
                    print("Erro ao criar o pixel buffer.")
                    return
                }
                
                CVPixelBufferLockBaseAddress(pixelBuffer, [])
                defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }
                
                let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
                let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
                if let pixelBufferAddress = CVPixelBufferGetBaseAddress(pixelBuffer) {
                    texture.getBytes(pixelBufferAddress, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
                }
                
                if CVPixelBufferGetPixelFormatType(pixelBuffer) != kCVPixelFormatType_32BGRA {
                    print("Formato de pixel buffer inválido.")
                    return
                }
                
                // Em vez de modificar o pixel buffer original, criamos um novo
                if let watermarkedPixelBuffer = self.addWatermark(to: pixelBuffer, textureSize: CGSize(width: texture.width, height: texture.height), pixelBufferPool: pixelBufferPool) {
                    if !self.assetWriterPixelBufferInput.append(watermarkedPixelBuffer, withPresentationTime: CMTimeMakeWithSeconds(CACurrentMediaTime() - self.recordingStartTime, preferredTimescale: 1000)) {
                        print("Erro ao adicionar frame: \(self.assetWriter.error?.localizedDescription ?? "Desconhecido")")
                    }
                } else {
                    print("Erro ao adicionar marca d'água")
                }
            }
        }
    }
    
    private func addWatermark(to pixelBuffer: CVPixelBuffer, textureSize: CGSize, pixelBufferPool: CVPixelBufferPool) -> CVPixelBuffer? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        guard let watermarkImage = watermarkImage,
              let watermarkCGImage = watermarkImage.cgImage else { return pixelBuffer }
        
        // Cria a imagem da marca d'água como um CIImage
        let watermarkCIImage = CIImage(cgImage: watermarkCGImage)
        
        // Aplica a transparência (alpha)
        let alpha: CGFloat = 0.5
        if let filter = CIFilter(name: "CIConstantColorGenerator") {
            filter.setValue(CIColor(cgColor: UIColor(white: 1, alpha: alpha).cgColor), forKey: kCIInputColorKey)
            if let alphaImage = filter.outputImage?.cropped(to: watermarkCIImage.extent) {
                let compositedWatermark = watermarkCIImage.applyingFilter("CIMultiplyCompositing", parameters: [kCIInputBackgroundImageKey: alphaImage])
                
                // Escala a marca d'água para 30% da largura do frame
                let scale = 0.25
                let scaledWidth = textureSize.width * CGFloat(scale)
                let scaledHeight = scaledWidth * (compositedWatermark.extent.height / compositedWatermark.extent.width)
                
                // Redimensiona a marca d'água
                let scaledWatermark = compositedWatermark.transformed(by: CGAffineTransform(scaleX: scaledWidth / compositedWatermark.extent.width, y: scaledHeight / compositedWatermark.extent.height))
                
                // Calcula a posição no canto inferior direito
                let marginRight: CGFloat = 40
                let marginBottom: CGFloat = 80
                let position = CGPoint(x: textureSize.width - scaledWidth - marginRight,
                                       y: marginBottom)
                let watermarkPositioned = scaledWatermark.transformed(by: CGAffineTransform(translationX: position.x, y: position.y))
                
                // Compoe a marca d'água sobre o frame
                let compositedImage = watermarkPositioned.composited(over: ciImage)
                
                // Cria um novo pixel buffer a partir do pool
                var newPixelBuffer: CVPixelBuffer?
                let status = CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool, &newPixelBuffer)
                guard status == kCVReturnSuccess, let outputPixelBuffer = newPixelBuffer else {
                    print("Falha ao criar novo pixel buffer do pool")
                    return nil
                }
                
                // Renderiza a imagem composta no novo pixel buffer
                ciContext.render(compositedImage, to: outputPixelBuffer, bounds: compositedImage.extent, colorSpace: CGColorSpaceCreateDeviceRGB())
                
                return outputPixelBuffer
            }
        }
        
        return pixelBuffer
    }
}

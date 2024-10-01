//The MIT License
//
//Copyright (c) 2017-2020 Laan Consulting Corp. http://labs.laan.com
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Foundation
import SceneKit
import ARKit

let vertsPerPoint = 8
let maxPoints = 20000
import simd

// Estrutura que contém as uniformes compartilhadas entre o shader e o código Swift
struct SharedUniforms {
    // Propriedades da Câmera
    var projectionMatrix: matrix_float4x4
    var viewMatrix: matrix_float4x4
    
    // Propriedades de Iluminação
    var ambientLightColor: vector_float3
    var directionalLightDirection: vector_float3
    var directionalLightColor: vector_float3
    
    var materialShininess: Float
}

// Estrutura do Vertex
struct Vertex {
    var position: vector_float4
    var color: vector_float4
    var normal: vector_float4
}

struct Stroke {
    var points: [SCNVector3]
    var startVertIndex: Int
    var startIndexIndex: Int
}

class VertBrush {
    // MARK: Metal
    var vertexBuffer: MTLBuffer! = nil
    var indexBuffer: MTLBuffer! = nil
    
    var pipelineState: MTLRenderPipelineState! = nil
    var depthState: MTLDepthStencilState!
    
    var strokes = [Stroke]()
    
    var points = [SCNVector3]()
    
    var lastVertUpdateIdx = 0
    var lastIndexUpdateIdx = 0
    
    var prevPerpVec = SCNVector3Zero
    
    var currentVertIndex: Int = 0
    var currentIndexIndex: Int = 0
    
    func addVert(_ v: Vertex) {
        let bufferContents = vertexBuffer.contents()
        let buffer = bufferContents.assumingMemoryBound(to: Vertex.self)
        buffer[currentVertIndex] = v
        currentVertIndex += 1
    }
    
    func addIndex(_ i: UInt32) {
        let bufferContents = indexBuffer.contents()
        let buffer = bufferContents.assumingMemoryBound(to: UInt32.self)
        buffer[currentIndexIndex] = i
        currentIndexIndex += 1
    }
    
    func addPoint(_ point: SCNVector3,
                  radius: Float = 0.01,
                  color: SCNVector3,
                  splitLine: Bool = false) {
        
        if points.count >= maxPoints {
            print("Max points reached")
            return
        }
        
        points.append(point)
        
        if points.count == 1 {
            strokes.append(Stroke(points: [point], startVertIndex: currentVertIndex, startIndexIndex: currentIndexIndex))
            return
        }
        
        if splitLine {
            prevPerpVec = SCNVector3Zero
            strokes.append(Stroke(points: [point], startVertIndex: currentVertIndex, startIndexIndex: currentIndexIndex))
            return
        }
        
        func toVert(_ pp: SCNVector3, _ nn: SCNVector3) -> Vertex {
            return Vertex(position: vector_float4(pp.x, pp.y, pp.z, 1.0),
                          color: vector_float4(color.x, color.y, color.z, 1.0),
                          normal: vector_float4(nn.x, nn.y, nn.z, 1.0))
        }
        
        let pidx = points.count - 1
        let p1 = points[pidx]
        let p2 = points[pidx - 1]
        let v1 = p1 - p2
        var v2 = SCNVector3Zero
        
        if SCNVector3EqualToVector3(prevPerpVec, SCNVector3Zero) {
            v2 = v1.cross(vector: SCNVector3(1.0, 1.0, 1.0)).normalized() * radius
        } else {
            v2 = SCNVector3ProjectPlane(vector: prevPerpVec, planeNormal: v1.normalized()).normalized() * radius
        }
        
        prevPerpVec = v2
        
        if points.count == 2 || strokes.last!.points.count == 1 {
            for i in 0..<vertsPerPoint {
                let angle = (Float(i) / Float(vertsPerPoint)) * Float.pi * 2.0
                let v3 = SCNVector3Rotate(vector: v2, around: v1, radians: angle)
                addVert(toVert(p2 + v3, v3.normalized()))
            }
        }
        
        let idx_start: UInt32 = UInt32(currentVertIndex)
        
        for i in 0..<vertsPerPoint {
            let angle = (Float(i) / Float(vertsPerPoint)) * Float.pi * 2.0
            let v3 = SCNVector3Rotate(vector: v2, around: v1, radians: angle)
            addVert(toVert(p1 + v3, v3.normalized()))
        }
        
        let N: UInt32 = UInt32(vertsPerPoint)
        for i in 0..<vertsPerPoint {
            let idx: UInt32 = idx_start + UInt32(i)
            if i == vertsPerPoint - 1 {
                addIndex(idx)
                addIndex(idx - N)
                addIndex(idx_start - N)
                addIndex(idx)
                addIndex(idx_start - N)
                addIndex(idx_start)
            } else {
                addIndex(idx)
                addIndex(idx - N)
                addIndex(idx - N + 1)
                addIndex(idx)
                addIndex(idx - N + 1)
                addIndex(idx + 1)
            }
        }
        
        strokes[strokes.count - 1].points.append(point)
    }
    
    func clear() {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        currentVertIndex = 0
        currentIndexIndex = 0
        points.removeAll()
        strokes.removeAll()
    }
    
    func removeLastStroke() {
        guard let lastStroke = strokes.popLast() else { return }
        
        let pointsToRemove = lastStroke.points.count
        if pointsToRemove > 0 {
            points.removeLast(pointsToRemove)
        }
        
        currentVertIndex = lastStroke.startVertIndex
        currentIndexIndex = lastStroke.startIndexIndex
    }
    
    var uniforms: SharedUniforms = SharedUniforms(
        projectionMatrix: matrix_float4x4(1.0),      // Matriz identidade ou outra matriz específica
        viewMatrix: matrix_float4x4(1.0),            // Matriz identidade ou outra matriz específica
        ambientLightColor: vector_float3(1.0, 1.0, 1.0), // Cor da luz ambiente (branco)
        directionalLightDirection: vector_float3(0.0, -1.0, 0.0), // Direção da luz
        directionalLightColor: vector_float3(1.0, 1.0, 1.0), // Cor da luz direcional (branco)
        materialShininess: 32.0 // Valor de brilho do material (padrão: 32.0)
    )
    
    func updateSharedUniforms(frame: ARFrame) {
        var ambientIntensity: Float = 1.0
        if let lightEstimate = frame.lightEstimate {
            ambientIntensity = Float(lightEstimate.ambientIntensity) / 1000.0
        }
        
        let ambientLightColor: vector_float3 = vector3(0.5, 0.5, 0.5)
        uniforms.ambientLightColor = ambientLightColor * ambientIntensity
        
        var directionalLightDirection: vector_float3 = vector3(0.0, 0.0, -1.0)
        directionalLightDirection = simd_normalize(directionalLightDirection)
        uniforms.directionalLightDirection = directionalLightDirection
        
        let directionalLightColor: vector_float3 = vector3(0.6, 0.6, 0.6)
        uniforms.directionalLightColor = directionalLightColor * ambientIntensity
        
        uniforms.materialShininess = 800
    }
    
    func render(_ commandQueue: MTLCommandQueue,
                _ renderEncoder: MTLRenderCommandEncoder,
                parentModelViewMatrix: float4x4,
                projectionMatrix: float4x4) {
        
        if currentIndexIndex == 0 { return }
        objc_sync_enter(self)
        
        renderEncoder.setCullMode(.back)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthStencilState(depthState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        uniforms.viewMatrix = parentModelViewMatrix
        uniforms.projectionMatrix = projectionMatrix
        
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<SharedUniforms>.stride, index: 1)
        renderEncoder.setFragmentBytes(&uniforms, length: MemoryLayout<SharedUniforms>.stride, index: 1)
        
        renderEncoder.drawIndexedPrimitives(type: .triangle,
                                            indexCount: currentIndexIndex,
                                            indexType: .uint32,
                                            indexBuffer: indexBuffer,
                                            indexBufferOffset: 0)
        
        objc_sync_exit(self)
    }
    
    func setupPipeline(device: MTLDevice, renderDestination: ARSCNView) {
        guard let defaultLibrary = device.makeDefaultLibrary() else {
            print("Failed to load default Metal library")
            return
        }
        
        guard let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex"),
              let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment") else {
            print("Shader functions not found in the library")
            return
        }
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = renderDestination.colorPixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat = renderDestination.depthPixelFormat
        
        let colorAttachment = pipelineStateDescriptor.colorAttachments[0]
        colorAttachment?.isBlendingEnabled = true
        colorAttachment?.rgbBlendOperation = .add
        colorAttachment?.alphaBlendOperation = .add
        colorAttachment?.sourceRGBBlendFactor = .one
        colorAttachment?.sourceAlphaBlendFactor = .one
        colorAttachment?.destinationRGBBlendFactor = .oneMinusSourceAlpha
        colorAttachment?.destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch {
            print("Error creating pipeline state: \(error)")
            return
        }
        
        let depthStateDescriptor = MTLDepthStencilDescriptor()
        depthStateDescriptor.depthCompareFunction = .greater
        depthStateDescriptor.isDepthWriteEnabled = true
        depthState = device.makeDepthStencilState(descriptor: depthStateDescriptor)
        
        let vertDataSize = vertsPerPoint * maxPoints * MemoryLayout<Vertex>.stride
        let indexDataSize = 3 * vertsPerPoint * maxPoints * MemoryLayout<UInt32>.stride
        vertexBuffer = device.makeBuffer(length: vertDataSize, options: .storageModeShared)
        indexBuffer = device.makeBuffer(length: indexDataSize, options: .storageModeShared)
    }
}


extension ARSCNView {

    func setup() { //SCENE SETUP
        antialiasingMode = .multisampling4X
        autoenablesDefaultLighting = true
        preferredFramesPerSecond = 60
        contentScaleFactor = 1.3

        if let camera = pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
            camera.maximumExposure = 3
        }
    }
}


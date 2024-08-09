//
//  SpirographExample.swift
//

import Foundation
import CoreGraphics
import Algorithms
import AVFoundation
import CoreImage

/// A sequence which will step through the points for drawing a spirograph shape with the specified radii & distances
func spirograph(innerRadius: Double, outerRadius: Double, distance: Double) -> some Sequence<CGPoint> {
    let Δradius = outerRadius - innerRadius
    let Δtheta = 0.01
    return sequence(state: 0.0) { theta in
        let x = Δradius * cos(theta) + distance * cos(Δradius * theta / innerRadius)
        let y = Δradius * sin(theta) + distance * sin(Δradius * theta / innerRadius)
        theta += Δtheta
        return CGPoint(x: x, y: y)
    }
}

extension Sequence {
    func reduce<Result>(first: (Iterator.Element) -> Result, updateAccumulatingResult: (inout Result, Iterator.Element) throws -> ()) rethrows -> Result? {
        var iterator = self.makeIterator()
        guard let firstElement = iterator.next() else { return nil }
        var result = first(firstElement)
        while let n = iterator.next() {
            try updateAccumulatingResult(&result, n)
        }
        return result
    }
}

extension Sequence where Element == CGPoint {
    func path() -> CGPath? {
        let path = reduce(first: { point in
            let path = CGMutablePath()
            path.move(to: point)
            return path
        }, updateAccumulatingResult: { partialResult, point in
            partialResult.addLine(to: point)
        })
        return path?.copy()
    }
}


fileprivate let imageSize = 1000
fileprivate let patternOffset = CGPoint(x: imageSize / 2, y: imageSize / 2)

func runSpirographExample() {
    let scale = 3.0
    let path = spirograph(innerRadius: 12, outerRadius: 105, distance: 31)
        .lazy
        .prefix(100_000)
        .map { ($0 * scale) + patternOffset }
        .path()
    
    guard let path else { return }
    
    let context = CGContext(data: nil,
                            width: imageSize,
                            height: imageSize,
                            bitsPerComponent: 8,
                            bytesPerRow: 0,
                            space: CGColorSpace(name: CGColorSpace.sRGB)!,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            
    context.saveGState()
    context.addPath(path)
    context.setLineWidth(1.0)
    context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    context.strokePath()
    let image = context.makeImage()
    context.restoreGState()
    
    runSpirographExample_gradient()
    runSpirographExample_another()
}


func runSpirographExample_gradient() {
    let scale = 7.0
    
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    let context = CGContext(data: nil,
                            width: imageSize,
                            height: imageSize,
                            bitsPerComponent: 8,
                            bytesPerRow: 0,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

let image = spirograph(innerRadius: 71, outerRadius: 38, distance: 28)
    .lazy
    .prefix(100_000)
    .map { ($0 * scale) + patternOffset }
    .adjacentPairs()
    .map { pointA, pointB in CGPath.line(from: pointA, to: pointB) }
    .enumerated()
    .lazy
    .map { index, path in
        let hue = (Double(index) / 255.0).truncatingRemainder(dividingBy: 1.0)
        return (hue, path)
    }
    .reduce(into: context) { context, content in
        let (hue, path) = content
        context.saveGState()
        context.addPath(path)
        context.setStrokeColor(.hue(hue))
        context.strokePath()
        context.restoreGState()
    }
    .makeImage()
    print(image)
}

func runSpirographExample_another() {
    let scale = 3.0
    
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    let context = CGContext(data: nil,
                            width: imageSize,
                            height: imageSize,
                            bitsPerComponent: 8,
                            bytesPerRow: 0,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

let image = spirograph(innerRadius: -47, outerRadius: 48, distance: 13)
    .lazy
    .prefix(100_00)
    .map { ($0 * scale) + patternOffset }
    .adjacentPairs()
    .map { pointA, pointB in CGPath.line(from: pointA, to: pointB) }
    .reduce(into: context) { context, path in
        context.saveGState()
        context.addPath(path)
        context.setStrokeColor(CGColor(gray: 1.0, alpha: 1.0))
        context.strokePath()
        context.restoreGState()
    }
    .makeImage()
    print(image)
}


@available(macOS 13.0, *)
func runSpirographExample_variousSamples() throws {
    let scale = 3.0
    
    struct Settings {
        var outer: Double
        var inner: Double
        var distance: Double
    }
    
    
    var downloadsFolder = try FileManager().url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    downloadsFolder.append(path: "spirograph_images_2", directoryHint: .isDirectory)
    try FileManager().createDirectory(at: downloadsFolder, withIntermediateDirectories: true)
    
    
    let settings = [
        Settings(outer: 48, inner: -47, distance: 13),
        Settings(outer: 105, inner: 7, distance: 12),
        Settings(outer: 96, inner: -20, distance: 56),
        Settings(outer: 96, inner: -30, distance: 60),
        Settings(outer: 100, inner: -10, distance: -10),
        Settings(outer: 105, inner: 12, distance: 31),
    ]
    
    
    let s2 = product(product(0...100, 0...100), 0...1)
        .lazy
        .map { (i,j) in
            let (m,n) = i
            return Settings(outer: Double(m), inner: Double(n), distance: Double(j))
        }
    
    for (index, setting) in settings.enumerated() {
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        let context = CGContext(data: nil,
                                width: imageSize,
                                height: imageSize,
                                bitsPerComponent: 8,
                                bytesPerRow: 0,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        let image = spirograph(innerRadius: setting.inner, outerRadius: setting.outer, distance: setting.distance)
        .lazy
        .prefix(100_00)
        .map { ($0 * scale) + patternOffset }
        .adjacentPairs()
        .map { pointA, pointB in CGPath.line(from: pointA, to: pointB) }
        .reduce(into: context) { context, path in
            context.saveGState()
            context.addPath(path)
            context.setStrokeColor(CGColor(gray: 1.0, alpha: 1.0))
            context.strokePath()
            context.restoreGState()
        }
        .makeImage()
        
        if let image {
            let destination = downloadsFolder.appending(components: "\(String(format: "%05d", index)).png", directoryHint: .notDirectory)
            image.save(to: destination)
        }
    }
}

@available(macOS 13.0, *)
func runSpirographExample_exportingAnimation() async throws {
    let scale = 7.0
    let framesPerSecond = 30
    
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    let context = CGContext(data: nil,
                            width: imageSize,
                            height: imageSize,
                            bitsPerComponent: 8,
                            bytesPerRow: 0,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    
    
    guard let pixelBuffer = createPixelBuffer(width: imageSize, height: imageSize) else { return }
    let ciContext = CIContext()
    
    
    var df = try FileManager().url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    df.append(path: "final_composed_video.mov", directoryHint: .notDirectory)
    
    await createAssetWriter(url: df, width: imageSize, height: imageSize) { assetWriterInput, assetWriterAdaptor in
       
        spirograph(innerRadius: 71, outerRadius: 38, distance: 28)
            .lazy
            .prefix(45_000)
            .map { ($0 * scale) + patternOffset }
            .adjacentPairs()
            .map { pointA, pointB in CGPath.line(from: pointA, to: pointB) }
            .enumerated()
            .lazy
            .map { index, path in
                let hue = (Double(index) / 255.0).truncatingRemainder(dividingBy: 1.0)
                return (hue, path)
            }
            .chunks(ofCount: 200)
            .compactMap { chunk in
                chunk.reduce(into: context, { context, content in
                    let (hue, path) = content
                    context.saveGState()
                    context.addPath(path)
                    context.setStrokeColor(.hue(hue))
                    context.strokePath()
                    context.restoreGState()
                }).makeImage()
            }
            .enumerated()
            .forEach { frameCount, image in
                let staticImage = CIImage(cgImage: image)
                ciContext.render(staticImage, to: pixelBuffer)
                
                if assetWriterInput.isReadyForMoreMediaData {
                    let frameTime = CMTimeMake(value: Int64(frameCount), timescale: Int32(framesPerSecond))
                    //append the contents of the pixelBuffer at the correct time
                    assetWriterAdaptor.append(pixelBuffer, withPresentationTime: frameTime)
                }
            }
    }
}


func createPixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
    //create a variable to hold the pixelBuffer
    var pixelBuffer: CVPixelBuffer?
    //set some standard attributes
    let attrs = [
        kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
        kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
    ] as CFDictionary
    
    //create a buffer (notice it uses an in/out parameter for the pixelBuffer variable)
    CVPixelBufferCreate(kCFAllocatorDefault,
                        width,
                        height,
                        kCVPixelFormatType_32BGRA,
                        attrs,
                        &pixelBuffer)
    return pixelBuffer
}

func createAssetWriter(url: URL, width: Int, height: Int, callback: (AVAssetWriterInput, AVAssetWriterInputPixelBufferAdaptor) -> Void) async {
    // TODO: handle error
    guard let assetwriter = try? AVAssetWriter(outputURL: url, fileType: .mov) else { return }
    
    let assetWriterSettings = [AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: width, AVVideoHeightKey: height] as [String : Any]
    let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: assetWriterSettings)
    
    let assetWriterAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: nil)
    
    assetwriter.add(assetWriterInput)
    assetwriter.startWriting()
    assetwriter.startSession(atSourceTime: CMTime.zero)
    
    callback(assetWriterInput, assetWriterAdaptor)
    
    assetWriterInput.markAsFinished()
    await assetwriter.finishWriting()
}


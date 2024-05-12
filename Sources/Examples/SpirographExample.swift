//
//  SpirographExample.swift
//

import Foundation
import CoreGraphics
import Algorithms

/// A sequence which will step through the points for drawing a spirograph shape with the specified radii & distances
func spirograph(innerRadius: Double, outerRadius: Double, distance: Double) -> some Sequence<CGPoint> {
    let Δradius = outerRadius - innerRadius
    let Δtheta = 0.01
    return sequence(state: 0.0) { theta in
        let x = Δradius * cos(theta) + distance * cos(Δradius * theta / outerRadius)
        let y = Δradius * sin(theta) + distance * sin(Δradius * theta / outerRadius)
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
    let path = spirograph(innerRadius: 105, outerRadius: 12, distance: 31)
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

let image = spirograph(innerRadius: 38, outerRadius: 71, distance: 28)
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

@available(macOS 13.0, *)
func runSpirographExample_exportingAnimation() throws {
    let scale = 7.0
    
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    let context = CGContext(data: nil,
                            width: imageSize,
                            height: imageSize,
                            bitsPerComponent: 8,
                            bytesPerRow: 0,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    
    var downloadsFolder = try FileManager().url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    downloadsFolder.append(path: "spirograph_images", directoryHint: .isDirectory)
    try FileManager().createDirectory(at: downloadsFolder, withIntermediateDirectories: true)

    spirograph(innerRadius: 38, outerRadius: 71, distance: 28)
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
        .chunks(ofCount: 100)
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
        .forEach { index, image in
            let destination = downloadsFolder.appending(components: "\(String(format: "%05d", index)).png", directoryHint: .notDirectory)
            image.save(to: destination)
        }
}

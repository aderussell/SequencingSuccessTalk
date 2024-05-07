//
//  SpirographExample.swift
//

import Foundation
import CoreGraphics
import Algorithms
import AppKit

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

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func * (lhs: CGPoint, rhs: Double) -> CGPoint {
        CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}

extension CGPath {
    static func line(from: CGPoint, to: CGPoint) -> CGPath {
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}

extension CGColor {
    static func hue(_ hue: CGFloat) -> CGColor {
        let color = NSColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        return color.cgColor
    }
}


fileprivate let imageSize = 1000
fileprivate let patternOffset = CGPoint(x: imageSize / 2, y: imageSize / 2)

func runSpirographExample() {
    let scale = 3.0
    let path = spirograph(innerRadius: 105, outerRadius: 12, distance: 31)
        .prefix(100_000)
        .map { ($0 * scale) + patternOffset }
        .reduce(first: { point in
            let path = CGMutablePath()
            path.move(to: point)
            return path
        }, updateAccumulatingResult: { partialResult, point in
            partialResult.addLine(to: point)
        })
    
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
    context.saveGState()

    spirograph(innerRadius: 38, outerRadius: 71, distance: 28)
        .prefix(100_000)
        .map { ($0 * scale) + patternOffset }
        .adjacentPairs()
        .enumerated()
        .forEach({ (index, points) in
            let (pointA, pointB) = points
            
            let path = CGPath.line(from: pointA, to: pointB)
            
            context.saveGState()
            context.addPath(path)
            context.setLineWidth(1.0)
            let hue = (Double(index) / 255.0).truncatingRemainder(dividingBy: 1.0)
            context.setStrokeColor(.hue(hue))
            context.strokePath()
            context.restoreGState()
        })
    
    let image = context.makeImage()
    context.restoreGState()
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
    context.saveGState()
    
    var downloadsFolder = try FileManager().url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    downloadsFolder.append(path: "spirograph_images", directoryHint: .isDirectory)
    try FileManager().createDirectory(at: downloadsFolder, withIntermediateDirectories: true)

    spirograph(innerRadius: 38, outerRadius: 71, distance: 28)
        .prefix(100_000)
        .map { ($0 * scale) + patternOffset }
        .adjacentPairs()
        .enumerated()
        .forEach({ (index, points) in
            let (pointA, pointB) = points
            
            let path = CGPath.line(from: pointA, to: pointB)
            
            context.saveGState()
            context.addPath(path)
            context.setLineWidth(1.0)
            let hue = (Double(index) / 255.0).truncatingRemainder(dividingBy: 1.0)
            context.setStrokeColor(.hue(hue))
            context.strokePath()
            context.restoreGState()
            
            let image = context.makeImage()
            let destination = downloadsFolder.appending(components: "\(String(format: "%05d", index)).png", directoryHint: .notDirectory)
            
            if index.isMultiple(of: 100), let image, let destination = CGImageDestinationCreateWithURL(destination as CFURL, kUTTypePNG, 1, nil) {
                CGImageDestinationAddImage(destination, image, nil)
                CGImageDestinationFinalize(destination)
            }
        })
    
    context.restoreGState()
}

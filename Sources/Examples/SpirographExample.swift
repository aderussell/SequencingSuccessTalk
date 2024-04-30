//
//  SpirographExample.swift
//

import Foundation
import CoreGraphics
import Algorithms
import AppKit

/// A sequence which will step through the points for drawing a spirograph shape with the specified radii & distances
func spirograph(innerRadius: Double, outerRadius: Double, distance: Double) -> some Sequence<CGPoint> {
    let Δradius = innerRadius - outerRadius
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

extension CGMutablePath {
    static func create(initialPosition: CGPoint) -> Self {
        let path = Self()
        path.move(to: initialPosition)
        return path
    }
}

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}


func runSpirographExample() {
    let path = spirograph(innerRadius: 105, outerRadius: 12, distance: 7)
        .prefix(100_000)
        .map { $0 + CGPoint(x: 200, y: 200) }
        .reduce(first: { CGMutablePath.create(initialPosition: $0) }) { partialResult, point in
            partialResult.addLine(to: point)
        }
    
    guard let path else { return }
    
    let context = CGContext(data: nil,
                            width: Int(400),
                            height: Int(400),
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
    
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    let context = CGContext(data: nil,
                            width: Int(400),
                            height: Int(400),
                            bitsPerComponent: 8,
                            bytesPerRow: 0,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    context.saveGState()
    
    
    spirograph(innerRadius: 38, outerRadius: 71, distance: 14)
        .prefix(10_000)
        .map { $0 + CGPoint(x: 200, y: 200) }
        .adjacentPairs()
        .enumerated()
        .forEach({ element in
            let (index, points) = element
            let (pointA, pointB) = points
            
            let path = CGMutablePath()
            path.move(to: pointA)
            path.addLine(to: pointB)
            
            context.saveGState()
            context.addPath(path)
            context.setLineWidth(1.0)
            let color = NSColor(hue: (Double(index) / 255.0).truncatingRemainder(dividingBy: 1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            let cgColor = color.cgColor
            context.setStrokeColor(cgColor)
            context.strokePath()
            context.restoreGState()
        })
    
    let image = context.makeImage()
    context.restoreGState()
}

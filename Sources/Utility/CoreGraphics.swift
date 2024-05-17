//
//  CoreGraphics.swift
//
//

import CoreGraphics
import AppKit
import UniformTypeIdentifiers

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


extension CGImage {
    func save(to fileUrl: URL) {
        let type = UTType.png.identifier as CFString
        guard let destination = CGImageDestinationCreateWithURL(fileUrl as CFURL, type, 1, nil) else { return }
        CGImageDestinationAddImage(destination, self, nil)
        CGImageDestinationFinalize(destination)
    }
}

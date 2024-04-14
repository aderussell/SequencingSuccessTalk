//
//  FileStructureExample.swift
//

import Foundation
import Algorithms

public indirect enum FileSystemItem {
    case file(name: String)
    case folder(name: String, children: [FileSystemItem])
    
    public var isFolder: Bool {
        switch self {
        case .file:
            return false
        case .folder:
            return true
        }
    }
    public var isFile: Bool { !isFolder }
    
    public var name: String {
        switch self {
        case .file(let name):
            return name
        case .folder(let name, _):
            return name
        }
    }
    
    public var children: [FileSystemItem] {
        switch self {
        case .file(_):
            return []
        case .folder(_, let children):
            return children
        }
    }
}
    
public let fileSystem: FileSystemItem = .folder(
    name: "Root",
    children: [
        .folder(
            name: "Documents",
            children: [
                .file(name: "Document1.docx"),
                .file(name: "Document2.txt"),
                .folder(
                    name: "Reports",
                    children: [
                        .file(name: "Report2023.pdf"),
                        .file(name: "Report2024.pdf"),
                    ]
                )
            ]
        ),
        .folder(
            name: "Pictures",
            children: [
                .file(name: "Pic1.jpg"),
                .file(name: "Pic2.png"),
                .folder(
                    name: "Vacation",
                    children: [
                        .file(name: "Beach.jpg"),
                        .file(name: "Mountain.png"),
                        .file(name: "City.jpg"),
                    ]
                )
            ]
        ),
        .folder(
            name: "Music",
            children: [
                .file(name: "Song1.mp3"),
                .file(name: "Song2.mp3"),
                .folder(
                    name: "Artists",
                    children: [
                        .folder(
                            name: "Artist1",
                            children: [
                                .file(name: "Song3.mp3"),
                                .file(name: "Song4.mp3"),
                            ]
                        ),
                        .folder(
                            name: "Artist2",
                            children: [
                                .file(name: "Song5.mp3"),
                                .file(name: "Song6.mp3"),
                            ]
                        )
                    ]
                )
            ]
        )
    ]
)

func runFileSystemExample() {
    
    RecursiveSequence(element: fileSystem, keyPath: \.children)
        .lazy
        .map { $0.name }
        .forEach { print($0) }
    
    print("-----------------------------")
    
    RecursiveSequence(element: fileSystem, keyPath: \.children)
        .indices
        .forEach { print($0) }
    
    
    RecursiveSequence(element: fileSystem, keyPath: \.children)
        .lazy
        .indexed()
        .map { "\(String(repeating: "\t", count: $0.count-1))\($1.name)" }
        .forEach { print($0) }
    
}

// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

runLazyExample()
runThemeParkExample()
runFileSystemExample()
runMessagesExample()
runSpirographExample()
runGameOfLifeExample()

if #available(macOS 13.0, *) {
    try? runSpirographExample_exportingAnimation()
}

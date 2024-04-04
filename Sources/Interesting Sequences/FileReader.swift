//
//  FileReader.swift
//

import Foundation


public struct FileReaderSequence: Sequence {
    public typealias Element = String
    let fileURL: URL
    
    public init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    public class Iterator: IteratorProtocol {
        let fileURL: URL
        var filePtr: UnsafeMutablePointer<FILE>?
        
        init(fileURL: URL) {
            self.fileURL = fileURL
        }
        
        deinit {
            if let filePtr {
                fclose(filePtr)
            }
        }
        
        public func next() -> String? {
            var linecap: Int = 0
            var linePtr: UnsafeMutablePointer<CChar>?
            if filePtr == nil {
                filePtr = fopen(fileURL.path, "r")
            }
            if getline(&linePtr, &linecap, filePtr) > 0, let linePtr {
                let str = String(cString: linePtr).trimmingCharacters(in: .newlines)
                free(linePtr)
                return str
            }
            return nil
        }
    }
    
    public __consuming func makeIterator() -> Iterator {
        Iterator(fileURL: fileURL)
    }
}


public func readLines(ofFile fileURL: URL) -> UnfoldSequence<String, UnsafeMutablePointer<FILE>> {
    let file = fopen(fileURL.path, "r")
    return sequence(state: file!) { (filePtr) -> String? in
        var linePtr: UnsafeMutablePointer<CChar>?
        var linecap: Int = 0
        if getline(&linePtr, &linecap, filePtr) > 0, let linePtr {
            defer { free(linePtr) }
            return String(cString: linePtr).trimmingCharacters(in: .newlines)
        } else {
            fclose(filePtr)
            return nil
        }
    }
}

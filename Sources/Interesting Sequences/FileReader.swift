//
//  FileReader.swift
//

import Foundation

typealias LineState = (
    linePtr: UnsafeMutablePointer<CChar>?,
    linecap: Int,
    filePtr: UnsafeMutablePointer<FILE>?
)

func readLines(ofFile fileURL: URL) -> UnfoldSequence<String, LineState> {
    return readLines(ofFile: fileURL) { $0 }
}

func readLines<T>(ofFile fileURL: URL, _ closure: @escaping (String) -> T) -> UnfoldSequence<T, LineState> {
    let initialState: LineState = (linePtr: nil, linecap: 0, filePtr: fopen(fileURL.path, "r"))
    return sequence(state: initialState, next: { (state) -> T? in
        if getline(&state.linePtr, &state.linecap, state.filePtr) > 0, let linePtr = state.linePtr {
            let s = String(cString: linePtr)
            let t = s.trimmingCharacters(in: .newlines)
            return closure(t)
        } else {
            if let actualLine = state.linePtr  { free(actualLine) }
            fclose(state.filePtr)
            return nil
        }
    })
}

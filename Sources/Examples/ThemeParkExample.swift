//
//  ThemeParkExample.swift
//

import Foundation
import Algorithms

struct Attraction: Decodable {
    let name: String
    let minHeight: Int?
    let maxHeight: Int?
    let land: String?
    let attractionType: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case minHeight = "min-height"
        case maxHeight = "max-height"
        case land
        case attractionType = "type"
    }
}

struct ThemePark: Decodable {
    let tag: String
    let resort: String
    let name: String
    let rides: [Attraction]
}

struct ThemeParkArea {
    var name: String
    var subAreas: [ThemeParkArea]
    var attractions: [Attraction]
}

struct Resort: Decodable {
    let tag: String
    let name: String
}

struct AttractionSubType: Decodable {
    let tag: String
    let type: String
}

struct Base: Decodable {
    var resorts: [Resort]
    var types: [AttractionSubType]
    var parks: [ThemePark]
}

func runThemeParkExample() {
    let semaphore = DispatchSemaphore(value: 0)
    Task {
        defer { semaphore.signal() }
        try? await loadThemeParkContent()
    }
    semaphore.wait()
}

func loadThemeParkContent() async throws {
    let urlSession = URLSession.shared
    let url = URL(string: "https://adrianrussell.co.uk/demos/heights/data.json")!
    let (data, _) = try await urlSession.data(from: url)
    let base =  try JSONDecoder().decode(Base.self, from: data)
    
    // get all rides at Walt Disney World that someone 40 inches can ride
    base.parks
        .lazy
        .filter { $0.resort == "wdw" }
        .flatMap { $0.rides }
        .filter {
            guard let height = $0.maxHeight else { return true }
            return height >= 40
        }
        .grouped(by: \.land)
        .sorted(by: { $0.0 ?? "" < $1.0 ?? "" })
        .forEach { (key, value) in
            print(key ?? "Unknown Land")
            value.forEach {
                let height = ($0.minHeight != nil) ? "\($0.minHeight!) inches" : "No height"
                print("\t\($0.name) - \(height)")
            }
        }
}

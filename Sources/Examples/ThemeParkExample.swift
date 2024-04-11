//
//  ThemeParkExample.swift
//

import Foundation

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
    let (data, response) = try await urlSession.data(from: url)
    let base =  try JSONDecoder().decode(Base.self, from: data)
    print(base)
}

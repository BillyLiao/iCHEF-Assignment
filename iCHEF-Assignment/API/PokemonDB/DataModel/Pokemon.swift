import Foundation

struct Pokemon: Codable {
    let name: String
    let height: Int
    let weight: Int
    let id: Int
    let sprites: Sprites
    let types: [Types]
}

struct Sprites: Codable {
    let front_default: String
}

struct Types: Codable {
    let slot: Int
    let type: `Type`
}

struct `Type`: Codable {
    let name: String
}


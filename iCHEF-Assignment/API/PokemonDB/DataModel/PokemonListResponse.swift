import Foundation

struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable, Hashable {
    let name: String
    let url: String
}

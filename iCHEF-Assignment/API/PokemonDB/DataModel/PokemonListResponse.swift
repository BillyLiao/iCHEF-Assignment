import Foundation

struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable, Hashable, Identifiable {
    let id = UUID()
    let name: String
    let url: String
}

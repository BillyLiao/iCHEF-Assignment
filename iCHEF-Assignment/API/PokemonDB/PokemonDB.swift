import Foundation
import Combine

enum PokemonDB {
    static let apiClient = APIClient()
    static let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
}

extension PokemonDB {
    static func getList() -> AnyPublisher<PokemonListResponse, Error> {
        guard let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents")
        }

        let request = URLRequest(url: components.url!)

        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    static func getPokemon(url: String) -> AnyPublisher<Pokemon, Error> {
        guard let components = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents")
        }

        let request = URLRequest(url: components.url!)

        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

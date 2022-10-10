import Foundation
import Combine

enum PokemonListDB {
    static let apiClient = APIClient()
    static let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
}

enum APIPath: String {
    case base = ""
}

extension PokemonListDB {
    static func request(_ path: APIPath) -> AnyPublisher<PokemonListResponse, Error> {
        guard let components = URLComponents(url: baseURL.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents")
        }

        let request = URLRequest(url: components.url!)
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

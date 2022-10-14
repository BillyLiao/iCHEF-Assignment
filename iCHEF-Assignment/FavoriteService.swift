import Foundation

class FavoriteService: ObservableObject {
    private let userDefault = UserDefaults.standard
    private let favKey = "Favorites"

    // TODO: Use Set Instead
    @Published var favs: [String] = [] {
        didSet {
            save()
        }
    }

    init() {
        guard let savedFavs = userDefault.value(forKey: favKey) as? [String] else { return }
        favs = savedFavs
    }

    func toggle(_ name: String) {
        isFavorite(name) ? unlike(name) : like(name)
    }

    func isFavorite(_ name: String) -> Bool {
        favs.contains(name)
    }

    private func like(_ name: String) {
        favs.append(name)
    }

    private func unlike(_ name: String) {
        favs.removeAll{ $0 == name }
    }

    private func save() {
        userDefault.set(favs, forKey: favKey)
    }
}

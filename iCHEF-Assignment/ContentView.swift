import SwiftUI
import Combine

struct ContentView: View {

    @StateObject private var vm = ViewModel()

    var body: some View {
        TabView {
            PokemonListView(vm).tabItem {
                Image(systemName: "list.bullet")
                Text("Pokemon").tag(1)
            }

            PokemonFavoriteView(vm).tabItem {
                Image(systemName: "heart")
                Text("Favorite").tag(2)
            }
        }
        .onAppear {
            vm.load()
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        private var cancellables = Set<AnyCancellable>()
        private let userDefault = UserDefaults.standard
        private let favKey = "Favorites"
        @Published var rowModels: [RowModel] = []
        @Published var favRowModels: [RowModel] = []
        @Published private var favorites: [String] = [] {
            didSet {
                save()
            }
        }

        init() {
            guard let savedFavs = userDefault.value(forKey: favKey) as? [String] else { return }
            favorites = savedFavs

            $rowModels
                .map { $0.filter { $0.isFavorite } }
                .assign(to: \.favRowModels, on: self)
                .store(in: &cancellables)

            $favorites
                .map { favs in
                    self.rowModels.map { .init(name: $0.name, url: $0.url, isFavorite: favs.contains($0.name)) }
                }
                .assign(to: \.rowModels, on: self)
                .store(in: &cancellables)
        }

        func load() {
            PokemonDB.getList()
                .mapError{ error -> Error in
                    print(error)
                    return error
                }
                .sink(receiveCompletion: { _ in },
                      receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.rowModels = response.results.map {
                        RowModel(name: $0.name, url: $0.url, isFavorite: self.isFavorite($0.name))
                    }
                })
                .store(in: &cancellables)
        }

        func toggle(_ name: String) {
            isFavorite(name) ? unlike(name) : like(name)
        }

        private func like(_ name: String) {
            favorites.append(name)
        }

        private func unlike(_ name: String) {
            favorites.removeAll{ $0 == name }
        }

        private func isFavorite(_ name: String) -> Bool {
            favorites.contains(name)
        }

        private func save() {
            userDefault.set(favorites, forKey: favKey)
        }
    }

    struct RowModel: Identifiable {
        let id = UUID()
        var name: String
        var url: String
        var buttonIcon: Image {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
        }
        var isFavorite: Bool
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

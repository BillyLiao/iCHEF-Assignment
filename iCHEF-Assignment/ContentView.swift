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
            // An workaround to solve tab bar color change when the list's empty
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        private var cancellables = Set<AnyCancellable>()

        @ObservedObject var favService: FavoriteService = .init()
        @Published var rowModels: [RowModel] = []
        @Published var favRowModels: [RowModel] = []

        init() {
            $rowModels
                .map { $0.filter { $0.isFavorite } }
                .assign(to: \.favRowModels, on: self)
                .store(in: &cancellables)

            favService.$favs
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
                        RowModel(name: $0.name, url: $0.url, isFavorite: self.favService.isFavorite($0.name))
                    }
                })
                .store(in: &cancellables)
        }

        func toggle(_ name: String) {
            favService.toggle(name)
        }
    }

    struct RowModel: Identifiable {
        let id = UUID()
        let name: String
        let url: String
        var buttonIcon: Image {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
        }
        let isFavorite: Bool
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI
import Combine

struct ContentView: View {

    @StateObject private var vm = ViewModel()

    var body: some View {
        TabView {
            listView(vm.rowModels)
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Pokemon").tag(1)
            }

            listView(vm.favRowModels)
            .tabItem {
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

    private func listView(_ rowModels: [PokemonListView.RowModel]) -> some View {
        PokemonListView(rowModels: rowModels) {
            vm.toggle($0)
        } destination: { model in
            .init(name: model.name, url: model.url, favService: vm.favService)
        }
    }
}

private extension ContentView {
    class ViewModel: ObservableObject {
        private var cancellables = Set<AnyCancellable>()

        @ObservedObject var favService: FavoriteService = .init()
        @Published var rowModels: [PokemonListView.RowModel] = []
        @Published var favRowModels: [PokemonListView.RowModel] = []

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
                        PokemonListView.RowModel(name: $0.name, url: $0.url, isFavorite: self.favService.isFavorite($0.name))
                    }
                })
                .store(in: &cancellables)
        }

        func toggle(_ name: String) {
            favService.toggle(name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

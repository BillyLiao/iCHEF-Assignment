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
        private var cancellationToken: AnyCancellable?
        @Published var rowModels: [RowModel] = []
        @Published var favoriteRowModels: [RowModel] = []

        private var favorites: [String] = [] {
            didSet {
                rowModels = rowModels.map {
                    .init(name: $0.name,
                          url: $0.url,
                          buttonIcon: self.getButtonIcon(of: $0.name))
                }

                favoriteRowModels = rowModels.filter { isFavorite($0.name) }
            }
        }

        func load() {
            cancellationToken = PokemonDB.getList()
                .mapError{ error -> Error in
                    print(error)
                    return error
                }
                .sink(receiveCompletion: { _ in },
                      receiveValue: { response in
                    self.rowModels = response.results.map { [weak self] item in
                        guard let self = self else {
                            return .init(name: "", url: "", buttonIcon: .init(systemName: "heart"))
                        }

                        return RowModel(name: item.name,
                                        url: item.url,
                                        buttonIcon: self.getButtonIcon(of: item.name))
                    }
                })
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

        private func getButtonIcon(of name: String) -> Image {
            Image(systemName: isFavorite(name) ? "heart.fill" : "heart")
        }
    }

    struct RowModel: Identifiable {
        let id = UUID()
        var name: String
        var url: String
        var buttonIcon: Image
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

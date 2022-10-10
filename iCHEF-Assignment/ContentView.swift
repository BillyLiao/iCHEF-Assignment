import SwiftUI
import Combine

struct ContentView: View {

    @StateObject private var viewModel = ViewModel()

    var body: some View {

        TabView {
            PokemonListView(viewModel: viewModel).tabItem {
                NavigationLink(destination: PokemonListView(viewModel: viewModel)) {
                    Image(systemName: "list.bullet")
                    Text("Pokemon").tag(1)
                }
            }

            PokemonFavoriteView(viewModel: viewModel).tabItem {
                NavigationLink(destination: PokemonFavoriteView(viewModel: viewModel)) {
                    Image(systemName: "heart")
                    Text("Favorite").tag(2)
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        var cancellationToken: AnyCancellable?
        @Published var items: [PokemonListItem] = []

        func load() {
            cancellationToken = PokemonDB.getList()
                .mapError{ error -> Error in
                    print(error)
                    return error
                }
                .sink(receiveCompletion: { _ in },
                      receiveValue: { response in
                    self.items = response.results
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

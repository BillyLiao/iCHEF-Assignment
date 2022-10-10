import SwiftUI
import Combine

struct ContentView: View {

    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .onAppear {
            viewModel.load()
        }
        .padding()
    }
}

private extension ContentView {
    class ViewModel: ObservableObject {
        var cancellationToken: AnyCancellable?
        @Published var items: [PokemonListItem] = []

        func load() {
            cancellationToken = PokemonListDB.request(.base)
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

import SwiftUI
import Combine

struct PokemonDetailView: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            HStack {
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: viewModel.pokemon.sprites.front_default)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.1)
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(16)

                    Text("ID：\(viewModel.pokemon.id)")
                    Text("Name：\(viewModel.pokemon.name)")
                    Text("Height：\(viewModel.pokemon.height)")
                    Text("Weight：\(viewModel.pokemon.weight)")
                    let types = viewModel.pokemon.types.map { $0.type.name }.joined(separator: ", ")
                    Text("Types：\(types)")

                    Spacer()
                }
                .padding(.leading, 24)

                Spacer()
            }
            .onAppear {
                viewModel.loadData()
            }
        }
    }

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

extension PokemonDetailView {
    class ViewModel: ObservableObject {
        private let url: String
        private var cancellationToken: AnyCancellable?

        @Published var pokemon: Pokemon = .init(name: "", height: 0, weight: 0, id: 0, sprites: .init(front_default: ""), types: [])
        
        init(_ url: String) {
            self.url = url
        }
        
        func loadData() {
            cancellationToken = PokemonDB.getPokemon(url: url)
                .mapError{ error -> Error in
                    print(error)
                    return error
                }
                .sink(receiveCompletion: { _ in },
                      receiveValue: { response in
                    self.pokemon = response
                })
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(.init("1"))
    }
}

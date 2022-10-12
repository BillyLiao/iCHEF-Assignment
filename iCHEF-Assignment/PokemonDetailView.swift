import SwiftUI
import Combine

struct PokemonDetailView: View {

    @ObservedObject var vm: ViewModel

    var body: some View {
        NavigationView {
            HStack {
                VStack(alignment: .leading) {
                    imageView()

                    Text("ID：\(vm.pokemon.id)")
                    Text("Name：\(vm.pokemon.name)")
                    Text("Height：\(vm.pokemon.height)")
                    Text("Weight：\(vm.pokemon.weight)")
                    Text("Types：\(vm.types)")

                    Spacer()
                }
                .padding(.leading, 24)

                Spacer()
            }
            .onAppear {
                vm.loadData()
            }
        }
    }

    init(_ vm: ViewModel) {
        self.vm = vm
    }

    private func imageView() -> some View {
        AsyncImage(url: URL(string: vm.pokemon.sprites.front_default)) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Color.gray.opacity(0.1)
        }
        .frame(width: 100, height: 100)
        .cornerRadius(16)
    }
}

extension PokemonDetailView {
    class ViewModel: ObservableObject {
        private let url: String
        private var cancellationToken: AnyCancellable?

        @Published var pokemon: Pokemon = .init(name: "", height: 0, weight: 0, id: 0, sprites: .init(front_default: ""), types: [])

        var types: String {
            pokemon.types.map { $0.type.name }.joined(separator: ", ")
        }

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

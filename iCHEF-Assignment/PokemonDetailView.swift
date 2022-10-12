import SwiftUI
import Combine

struct PokemonDetailView: View {

    @ObservedObject var vm: ViewModel

    var body: some View {
        NavigationView {
            HStack {
                VStack(alignment: .leading) {
                    imageView

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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.toggle()
                } label: {
                    vm.toolBarIcon
                }.buttonStyle(.plain)
            }
        }
    }

    var imageView: some View {
        AsyncImage(url: URL(string: vm.pokemon.sprites.front_default)) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Color.gray.opacity(0.1)
        }
        .frame(width: 100, height: 100)
        .cornerRadius(16)
    }

    init(_ vm: ViewModel) {
        self.vm = vm
    }
}

extension PokemonDetailView {
    class ViewModel: ObservableObject {
        private let url: String
        private var cancellables = Set<AnyCancellable>()

        @ObservedObject var favService: FavoriteService
        @Published var toolBarIcon: Image = .init(systemName: "heart")
        @Published var pokemon: Pokemon = .init(name: "",
                                                height: 0,
                                                weight: 0,
                                                id: 0,
                                                sprites: .init(front_default: ""),
                                                types: [])

        var types: String {
            pokemon.types.map { $0.type.name }.joined(separator: ", ")
        }

        init(name: String, url: String, favService: FavoriteService) {
            self.url = url
            self.favService = favService
            self.favService.$favs
                .map { Image(systemName: $0.contains(name) ? "heart.fill" : "heart") }
                .assign(to: \.toolBarIcon, on: self)
                .store(in: &cancellables)
        }

        func loadData() {
            PokemonDB.getPokemon(url: url)
                .mapError{ error -> Error in
                    print(error)
                    return error
                }
                .sink(receiveCompletion: { _ in },
                      receiveValue: { response in
                    self.pokemon = response
                })
                .store(in: &cancellables)
        }

        func toggle() {
            favService.toggle(pokemon.name)
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(.init(name: "", url: "", favService: .init()))
    }
}

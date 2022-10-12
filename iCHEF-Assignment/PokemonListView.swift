import SwiftUI

struct PokemonListView: View {

    @ObservedObject var vm: ContentView.ViewModel
    var action: ((String) -> ())?
    var rowModels: [RowModel]

    init(_ vm: ContentView.ViewModel, rowModels: [RowModel], _ action: @escaping (String) -> ()) {
        self.action = action
        self.vm = vm
        self.rowModels = rowModels
    }

    var body: some View {
        NavigationStack {
            List(rowModels) { model in
                ZStack {
                    NavigationLink(destination: PokemonDetailView(
                        .init(name: model.name, url: model.url, favService: vm.favService))
                    ) {
                        EmptyView()
                    }.opacity(0)
                    rowView(model)
                }
            }
        }
    }

    private func rowView(_ model: RowModel) -> some View {
        HStack {
            Text(model.name)

            Spacer()

            Button {
                action?(model.name)
            } label: {
                model.buttonIcon
            }.buttonStyle(.plain)
        }
    }
}

extension PokemonListView {
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
struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(.init(), rowModels: []) { _ in }
    }
}

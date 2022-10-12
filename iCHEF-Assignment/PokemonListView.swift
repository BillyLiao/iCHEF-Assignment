import SwiftUI

struct PokemonListView: View {

    private var action: ((String) -> ())?
    private var destination: ((RowModel) -> PokemonDetailView)
    private var rowModels: [RowModel]

    init(rowModels: [RowModel],
         _ action: @escaping (String) -> (),
         destination: @escaping (RowModel) -> PokemonDetailView)
    {
        self.action = action
        self.rowModels = rowModels
        self.destination = destination
    }

    var body: some View {
        NavigationStack {
            List(rowModels) { model in
                ZStack {
                    NavigationLink(destination: destination(model)) {
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
        PokemonListView(rowModels: []) { _ in
        } destination: { model in
            .init(name: model.name, url: model.url, favService: .init())
        }
    }
}

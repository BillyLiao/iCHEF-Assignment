import SwiftUI

struct PokemonListView: View {

    @ObservedObject var viewModel: ContentView.ViewModel

    init(_ viewModel: ContentView.ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List(viewModel.rowModels) { model in
                ZStack {
                    NavigationLink(destination: PokemonDetailView(.init(model.url))) {
                        EmptyView()
                    }.opacity(0)
                    rowView(model)
                }
            }
        }
    }

    private func rowView(_ model: ContentView.RowModel) -> some View {
        HStack {
            Text(model.name)

            Spacer()

            Button {
                viewModel.toggle(model.name)
            } label: {
                model.buttonIcon
            }.buttonStyle(.plain)
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(.init())
    }
}

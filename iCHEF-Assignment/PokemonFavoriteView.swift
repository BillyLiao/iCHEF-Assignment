import SwiftUI

struct PokemonFavoriteView: View {

    @ObservedObject var viewModel: ContentView.ViewModel

    init(_ viewModel: ContentView.ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favRowModels) { model in
                    ZStack {
                        NavigationLink(destination: PokemonDetailView(.init(model.url))) {
                            EmptyView()
                        }.opacity(0)
                        rowView(model.name)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach {
                        let name = viewModel.favRowModels[$0].name
                        viewModel.toggle(name)
                    }
                }
            }
        }
    }

    private func rowView(_ name: String) -> some View {
        HStack {
            Text(name)
            Spacer()
        }
    }
}

struct PokemonFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonFavoriteView(.init())
    }
}

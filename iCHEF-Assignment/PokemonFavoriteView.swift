import SwiftUI

struct PokemonFavoriteView: View {

    @ObservedObject var viewModel: ContentView.ViewModel

    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                ZStack {
                    NavigationLink(destination: PokemonDetailView(.init(item.url))) {
                        EmptyView()
                    }.opacity(0)
                    rowView(name: item.name)
                }
            }
        }
    }

    private func rowView(name: String) -> some View {
        HStack() {
            Text(name)

            Spacer()
        }
    }
}

struct PokemonFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonFavoriteView(viewModel: .init())
    }
}

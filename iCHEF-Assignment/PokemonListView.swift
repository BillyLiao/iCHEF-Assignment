import SwiftUI

struct PokemonListView: View {

    @ObservedObject var viewModel: ContentView.ViewModel

    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                ZStack {
                    NavigationLink(destination: PokemonDetailView(.init(item.url))) {
                        EmptyView()
                    }.opacity(0)
                    rowView(name: item.name, isFavorite: false)
                }
            }
        }
    }

    private func rowView(name: String, isFavorite: Bool) -> some View {
        HStack {
            Text(name)

            Spacer()

            Button {
                // TODO: Do sth
                print("Tapped!")
            } label: {
                Image(systemName: "heart")
            }
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(viewModel: .init())
    }
}

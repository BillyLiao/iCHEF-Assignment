import SwiftUI

struct PokemonFavoriteView: View {

    @ObservedObject var viewModel: ContentView.ViewModel

    var body: some View {
        List {
            ForEach(viewModel.items, id: \.self) { item in
                HStack {
                    Text(item.name)

                    Spacer()
                }
            }
            .onDelete { offset in
                // TODO: Do sth
            }
        }
    }
}

struct PokemonFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonFavoriteView(viewModel: .init())
    }
}

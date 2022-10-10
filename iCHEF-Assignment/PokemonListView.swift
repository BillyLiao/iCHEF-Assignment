import SwiftUI

struct PokemonListView: View {

    @ObservedObject var viewModel: ContentView.ViewModel

    var body: some View {
        List {
            ForEach(viewModel.items, id: \.self) { item in
                HStack {
                    Text(item.name)

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
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(viewModel: .init())
    }
}

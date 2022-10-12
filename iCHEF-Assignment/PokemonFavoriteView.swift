import SwiftUI

struct PokemonFavoriteView: View {

    @ObservedObject var vm: ContentView.ViewModel

    init(_ vm: ContentView.ViewModel) {
        self.vm = vm
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.favRowModels) { model in
                    ZStack {
                        NavigationLink(destination: PokemonDetailView(
                            .init(name: model.name, url: model.url, favService: vm.favService))
                        ) {
                            EmptyView()
                        }.opacity(0)
                        rowView(model)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach {
                        let name = vm.favRowModels[$0].name
                        vm.toggle(name)
                    }
                }
            }
        }
    }

    private func rowView(_ model: ContentView.RowModel) -> some View {
        HStack {
            Text(model.name)
            Spacer()
        }
    }
}

struct PokemonFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonFavoriteView(.init())
    }
}

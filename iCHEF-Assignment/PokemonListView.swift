import SwiftUI

struct PokemonListView: View {

    @ObservedObject var vm: ContentView.ViewModel

    init(_ vm: ContentView.ViewModel) {
        self.vm = vm
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.rowModels) { model in
                    ZStack {
                        NavigationLink(destination: PokemonDetailView(
                            .init(name: model.name, url: model.url, favService: vm.favService)
                        )) {
                            EmptyView()
                        }.opacity(0)
                        rowView(model)
                    }
                }
            }
        }
    }

    private func rowView(_ model: ContentView.RowModel) -> some View {
        HStack {
            Text(model.name)

            Spacer()

            Button {
                vm.toggle(model.name)
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

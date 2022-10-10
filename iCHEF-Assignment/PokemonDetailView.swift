import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!)

                Text("編號：1")
                Text("名稱：妙蛙種子")
                Text("身高：100cm")
                Text("體重：30kg")
                Text("屬性：草系")
            }
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView()
    }
}

import XCTest
import SwiftUI
import Combine
@testable import iCHEF_Assignment

final class PokemonDetailViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    let pokemonName = "ivysaur"
    let favKey = "Favorites"
    var favService: FavoriteService!
    var vm: PokemonDetailView.ViewModel!

    override func setUp() {
        UserDefaults.standard.setValue(nil, forKey: favKey)
        favService = .init()
        vm = .init(name: pokemonName,
                   url: "https://pokeapi.co/api/v2/pokemon/2/",
                   favService: favService)
    }

    override func tearDown() {
        UserDefaults.standard.setValue(nil, forKey: favKey)
    }

    func testFavIconInitialization() {
        XCTAssertEqual(vm.toolBarIcon, Image(systemName: "heart"))
        favService.toggle(pokemonName)
        vm = .init(name: pokemonName,
                   url: "https://pokeapi.co/api/v2/pokemon/2/",
                   favService: favService)
        XCTAssertEqual(vm.toolBarIcon, Image(systemName: "heart.fill"))
    }

    func testFavIconToggle() {
        XCTAssertEqual(vm.toolBarIcon, Image(systemName: "heart"))
        favService.toggle(pokemonName)
        XCTAssertEqual(vm.toolBarIcon, Image(systemName: "heart.fill"))
        favService.toggle(pokemonName)
        XCTAssertEqual(vm.toolBarIcon, Image(systemName: "heart"))
    }

    func testToggleWithPokemon() {
        vm.pokemon = .init(name: pokemonName,
                           height: 0,
                           weight: 0,
                           id: 0,
                           sprites: .init(front_default: ""),
                           types: [])

        vm.toggle()
        XCTAssertFalse(favService.favs.isEmpty)
        XCTAssertEqual(favService.favs.count, 1)
        XCTAssertEqual(favService.favs[0], pokemonName)
    }

    func testToggleWithoutPokemon() {
        vm.toggle()
        XCTAssertFalse(favService.favs.isEmpty)
        XCTAssertEqual(favService.favs.count, 1)
        XCTAssertEqual(favService.favs[0], "")
    }

    func testTypesConcatenation() {
        vm.pokemon = .init(name: "",
                           height: 0,
                           weight: 0,
                           id: 0,
                           sprites: .init(front_default: ""),
                           types: [.init(slot: 0, type: .init(name: "fire")),
                                   .init(slot: 1, type: .init(name: "ice")),
                                   .init(slot: 2, type: .init(name: "grass"))])
        XCTAssertEqual(vm.types, "fire, ice, grass")
    }

    func testLoadData() {
        let expectation = XCTestExpectation(description: "load data")
        vm.loadData()
        vm.$pokemon
          .dropFirst()
          .sink { value in
              XCTAssertEqual(value.name, self.pokemonName)
              expectation.fulfill()
          }
          .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}

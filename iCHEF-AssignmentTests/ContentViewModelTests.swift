import XCTest
import Combine
@testable import iCHEF_Assignment

final class ContentViewModelTests: XCTestCase {

    var vm: ContentView.ViewModel = .init()
    var cancellables = Set<AnyCancellable>()
    let pokemonName = "ivysaur"

    override func setUpWithError() throws {
        vm = .init()
    }

    override func tearDown() {
        UserDefaults.standard.setValue(nil, forKey: "Favorites")
    }

    func testLoadDataWithoutFavorites() throws {
        let expect = XCTestExpectation(description: "load data")
        vm.load()
        vm.$rowModels
          .dropFirst()
          .sink { rowModels in
              XCTAssertEqual(rowModels.count, 20)
              XCTAssertEqual(self.vm.favRowModels.count, 0)
              expect.fulfill()
          }
          .store(in: &cancellables)

        wait(for: [expect], timeout: 1)
    }

    func testLoadDataWithFavorites() throws {
        let expect = XCTestExpectation(description: "load data")
        vm.toggle(pokemonName)
        vm.load()
        vm.$rowModels
          .dropFirst()
          .sink { rowModels in
              XCTAssertEqual(rowModels.count, 20)
              XCTAssertEqual(self.vm.favService.favs.count, 1)
              XCTAssertEqual(self.vm.favService.favs[0], self.pokemonName)
              expect.fulfill()
          }
          .store(in: &cancellables)

        wait(for: [expect], timeout: 1)
    }

    func testAddToFavorite() throws {
        vm.rowModels = [.init(name: pokemonName, url: "", isFavorite: false)]
        XCTAssertEqual(vm.favRowModels.count, 0)
        vm.favService.toggle(pokemonName)
        XCTAssertEqual(vm.favRowModels.count, 1)
        XCTAssertEqual(vm.favRowModels[0].name, pokemonName)
    }

    func testRemoveFromFavorite() throws {
        vm.favService.toggle(pokemonName)
        vm.rowModels = [.init(name: pokemonName, url: "", isFavorite: true)]
        XCTAssertEqual(vm.favRowModels.count, 1)
        XCTAssertEqual(vm.favRowModels[0].name, pokemonName)
        vm.favService.toggle(pokemonName)
        XCTAssertEqual(vm.rowModels.count, 1)
        XCTAssertEqual(vm.favRowModels.count, 0)
    }
}

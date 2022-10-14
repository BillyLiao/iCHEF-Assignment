import XCTest
@testable import iCHEF_Assignment

final class FavoriteServiceTests: XCTestCase {

    var favService: FavoriteService = .init()
    let favKey = "Favorites"
    let userDefault = UserDefaults.standard
    let pokemonName = "ivysaur"

    override func tearDown() {
        userDefault.setValue(nil, forKey: favKey)
    }

    func testInitWithSavedFavs() {
        userDefault.setValue([pokemonName], forKey: favKey)
        favService = .init()
        XCTAssertEqual(favService.favs.count, 1)
        XCTAssertEqual(favService.favs[0], pokemonName)
    }

    func testToggle() throws {
        favService.toggle(pokemonName)
        XCTAssertEqual(favService.favs.count, 1)
        XCTAssertEqual(favService.favs[0], pokemonName)
        XCTAssertEqual(userDefault.value(forKey: favKey) as! [String], [pokemonName])
        favService.toggle(pokemonName)
        XCTAssertEqual(favService.favs, [])
        XCTAssertEqual(userDefault.value(forKey: favKey) as! [String], [])
    }

    func testIsFavorite() throws {
        favService.toggle(pokemonName)
        XCTAssertTrue(favService.isFavorite(pokemonName))
        favService.toggle(pokemonName)
        XCTAssertFalse(favService.isFavorite(pokemonName))
    }
}

import ComposableArchitecture
@testable import MyLibrary
import XCTest

final class MyLibraryTests: XCTestCase {
    func testExample() throws {
        let store = TestStore(initialState: AppFeature.State(),
                              reducer: { AppFeature() })
    }
}

import ComposableArchitecture
@testable import MyLibrary
import XCTest

import XCTest

@MainActor
class YourAppTests: XCTestCase {
    var yourApp: Blahker!

    override func setUp() {
        super.setUp()
        // 初始化您的應用程式實例，準備進行測試
        yourApp = Blahker()
    }

    override func tearDown() {
        // 清理測試中使用的資源
        yourApp = nil
        super.tearDown()
    }

    // 測試當使用者沒有啟用內容阻擋功能時的行為
    func testNoContentBlockingEnabled() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.safariService.checksContentBlockerEnabled = { _ in false }
        }

        await store.send(.entersForeground)
        await store.receive(.checksContentBlockerEnabled)
        await store.receive(.reportsUserContentBlockerStatus(false))
    }

    // 測試當使用者已啟用內容阻擋功能時的行為
    func testContentBlockingEnabled() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.safariService.checksContentBlockerEnabled = { _ in false }
        }

        await store.send(.entersForeground)
        await store.receive(.checksContentBlockerEnabled)
        await store.receive(.reportsUserContentBlockerStatus(false))
    }

    // 測試當使用者原本沒啟用阻擋功能，但提示後啟用的行為
    func testEnableContentBlockingAfterPrompt() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.safariService.checksContentBlockerEnabled = { _ in false }
        }

        await store.send(.entersForeground)
        await store.receive(.checksContentBlockerEnabled)
        await store.receive(.reportsUserContentBlockerStatus(false))

        store.dependencies.safariService.checksContentBlockerEnabled = { _ in true }
        await store.send(.entersForeground)
        await store.receive(.checksContentBlockerEnabled)
        await store.receive(.reportsUserContentBlockerStatus(true))
    }
}

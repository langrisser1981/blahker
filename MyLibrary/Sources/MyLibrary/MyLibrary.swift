// The Swift Programming Language
// https://docs.swift.org/swift-book

import ComposableArchitecture
import SwiftUI

@main
struct Blahker: App {
    var body: some Scene {
        WindowGroup {
            Text("hello world")
        }
    }
}

struct AppFeature: Reducer {
    struct State: Equatable {}

    enum Action: Equatable {
        case entersForeground
        case checksContentBlockerEnabled
        case reportsUserContentBlockerStatus(Bool)
    }

    @Dependency(\.safariService) var safariService

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .entersForeground:
            return .send(.checksContentBlockerEnabled)
        case .checksContentBlockerEnabled:
            return .run { send in
                let contentBlockerExteiosnIdentifier = "com.elaborapp.Blahker.ContentBlocker"
                let isEnabled = await safariService.checksContentBlockerEnabled(contentBlockerExteiosnIdentifier)
                await send(.reportsUserContentBlockerStatus(isEnabled))
            }
//            return .send(.reportsUserContentBlockerStatus(false))
        case .reportsUserContentBlockerStatus(let bool):
            return .none
        }
    }
}

// The Swift Programming Language
// https://docs.swift.org/swift-book

import ComposableArchitecture
import ContentBlockerService
import SwiftUI

@main
struct Blahker: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: Store(
                initialState: AppFeature.State(),
                reducer: { AppFeature() }
            ))
        }
    }
}

struct AppFeature: Reducer {
    struct State: Equatable {
        var isEnabledContentBlocer: Bool = false
    }

    enum Action: Equatable {
        case entersForeground
        case checksContentBlockerEnabled
        case reportsUserContentBlockerStatus(Bool)
    }

    @Dependency(\.contentBlockerService) var contentBlockerService

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .entersForeground:
            return .send(.checksContentBlockerEnabled)
        case .checksContentBlockerEnabled:
            return .run { send in
                let contentBlockerExteiosnIdentifier = "com.elaborapp.Blahker.ContentBlocker"
                let isEnabled = await contentBlockerService.checksContentBlockerEnabled(contentBlockerExteiosnIdentifier)
                await send(.reportsUserContentBlockerStatus(isEnabled))
            }
        case .reportsUserContentBlockerStatus(let bool):
            return .none
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        WithViewStore(store) { state in
            state.isEnabledContentBlocer
        } content: { viewStore in
            let isEnabledContentBlocker = viewStore.state
            Text("hello world \(isEnabledContentBlocker ? "yes" : "no")")
                .onChange(of: scenePhase) { scenePhase in
                    switch scenePhase {
                    case .active:
                        store.send(.entersForeground)
                    case .background, .inactive:
                        break
                    @unknown default:
                        break
                    }
                }
        }
    }
}

//
//  SafariService.swift
//
//
//  Created by 程信傑 on 2024/1/18.
//

import Dependencies
import Foundation
import SafariServices

struct SafariService {
    var checksContentBlockerEnabled: (String) async -> Bool
}

extension SafariService: DependencyKey {
    static var liveValue = SafariService { contentBlockerExteiosnIdentifier in
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: contentBlockerExteiosnIdentifier,
            completionHandler: { state, _ in
                switch state?.isEnabled {
                case .some(true):
                    break
                default:
                    break
                }
            })
        return true
    }
}

extension SafariService: TestDependencyKey {
    static var testValue = SafariService { _ in
        unimplemented("checksContentBlockerEnabled")
    }
}

extension DependencyValues {
    var safariService: SafariService {
        get { self[SafariService.self] }
        set { self[SafariService.self] = newValue }
    }
}

//
//  ContentBlockerService.swift
//
//
//  Created by 程信傑 on 2024/1/18.
//

import Dependencies
import Foundation
import SafariServices

public struct ContentBlockerService {
    public var checksContentBlockerEnabled: (String) async -> Bool
}

extension ContentBlockerService: DependencyKey {
    public static var liveValue = ContentBlockerService { bundleID in
        await withCheckedContinuation { continuation in
            SFContentBlockerManager.getStateOfContentBlocker(
                withIdentifier: bundleID,
                completionHandler: { state, _ in
                    switch state?.isEnabled {
                    case .some(true):
                        continuation.resume(returning: true)
                    default:
                        continuation.resume(returning: false)
                    }
                })
        }
    }
}

extension ContentBlockerService: TestDependencyKey {
    public static var testValue = ContentBlockerService { _ in
        unimplemented("checksContentBlockerEnabled")
    }
}

public extension DependencyValues {
    var contentBlockerService: ContentBlockerService {
        get { self[ContentBlockerService.self] }
        set { self[ContentBlockerService.self] = newValue }
    }
}

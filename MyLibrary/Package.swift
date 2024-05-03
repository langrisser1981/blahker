// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyLibrary",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]),
        .library(
            name: "ContentBlockerService",
            targets: ["ContentBlockerService"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MyLibrary",
            dependencies: [.contentBlockerService, .tca]),
        .testTarget(
            name: "MyLibraryTests",
            dependencies: ["MyLibrary", .tca]),
        .target(
            name: "ContentBlockerService",
            dependencies: [.tca]),
    ])

extension Target.Dependency {
    static let contentBlockerService: Self = "ContentBlockerService"
}

extension Target.Dependency {
    static let tca = Self.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
}

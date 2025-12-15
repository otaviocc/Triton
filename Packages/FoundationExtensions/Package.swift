// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "FoundationExtensions",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FoundationExtensions",
            targets: ["FoundationExtensions"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FoundationExtensions",
            dependencies: []
        ),
        .testTarget(
            name: "FoundationExtensionsTests",
            dependencies: ["FoundationExtensions"]
        )
    ]
)

// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AuthSession",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "AuthSessionService",
            targets: ["AuthSessionService"]
        ),
        .library(
            name: "AuthSessionServiceInterface",
            targets: ["AuthSessionServiceInterface"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AuthSessionServiceInterface",
            dependencies: []
        ),
        .target(
            name: "AuthSessionService",
            dependencies: ["AuthSessionServiceInterface"]
        ),
        .testTarget(
            name: "AuthSessionServiceTests",
            dependencies: ["AuthSessionService"]
        )
    ]
)

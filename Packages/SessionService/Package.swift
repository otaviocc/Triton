// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SessionService",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SessionService",
            targets: ["SessionService"]
        ),
        .library(
            name: "SessionServiceInterface",
            targets: ["SessionServiceInterface"]
        )
    ],
    dependencies: [
        .package(
            name: "Utilities",
            path: "../Utilities"
        )
    ],
    targets: [
        .target(
            name: "SessionService",
            dependencies: [
                .product(name: "Archiver", package: "Utilities"),
                "SessionServiceInterface"
            ]
        ),
        .testTarget(
            name: "SessionServiceTests",
            dependencies: ["SessionService"]
        ),
        .target(
            name: "SessionServiceInterface",
            dependencies: []
        )
    ]
)

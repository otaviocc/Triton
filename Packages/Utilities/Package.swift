// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Archiver",
            targets: ["Archiver"]
        ),
        .library(
            name: "ClipboardService",
            targets: ["ClipboardService"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Archiver",
            dependencies: []
        ),
        .target(
            name: "ClipboardService",
            dependencies: []
        ),
        .testTarget(
            name: "ArchiverTests",
            dependencies: ["Archiver"]
        )
    ]
)

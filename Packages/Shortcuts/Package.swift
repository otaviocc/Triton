// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Shortcuts",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Shortcuts",
            targets: ["Shortcuts"]
        )
    ],
    dependencies: [
        .package(name: "Route", path: "../Route")
    ],
    targets: [
        .target(
            name: "Shortcuts",
            dependencies: [
                "Route"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ShortcutsTests",
            dependencies: ["Shortcuts"],
            path: "Tests"
        )
    ]
)

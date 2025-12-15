// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Route",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Route",
            targets: ["Route"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Route",
            dependencies: []
        )
    ]
)

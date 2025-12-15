// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Account",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Account",
            targets: ["Account"]
        )
    ],
    dependencies: [
        .package(
            name: "DesignSystem",
            path: "../DesignSystem"
        ),
        .package(
            name: "SessionService",
            path: "../SessionService"
        ),
        .package(
            name: "AuthSession",
            path: "../AuthSession"
        ),
        .package(
            url: "https://github.com/otaviocc/MicroContainer.git",
            from: "0.0.6"
        ),
        .package(
            url: "https://github.com/otaviocc/MicroClient.git",
            from: "0.0.27"
        )
    ],
    targets: [
        .target(
            name: "Account",
            dependencies: [
                .product(name: "SessionServiceInterface", package: "SessionService"),
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                "DesignSystem",
                "MicroContainer",
                "MicroClient"
            ]
        )
    ]
)

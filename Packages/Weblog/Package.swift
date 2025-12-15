// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Weblog",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Weblog",
            targets: ["Weblog"]
        )
    ],
    dependencies: [
        .package(
            name: "SessionService",
            path: "../SessionService"
        ),
        .package(
            name: "AuthSession",
            path: "../AuthSession"
        ),
        .package(
            name: "DesignSystem",
            path: "../DesignSystem"
        ),
        .package(
            name: "OMGAPI",
            path: "../OMGAPI"
        ),
        .package(
            name: "Route",
            path: "../Route"
        ),
        .package(
            name: "Utilities",
            path: "../Utilities"
        ),
        .package(
            name: "FoundationExtensions",
            path: "../FoundationExtensions"
        ),
        .package(
            url: "https://github.com/otaviocc/MicroClient.git",
            from: "0.0.27"
        ),
        .package(
            url: "https://github.com/otaviocc/MicroContainer.git",
            from: "0.0.6"
        )
    ],
    targets: [
        .target(
            name: "Weblog",
            dependencies: [
                .product(name: "SessionServiceInterface", package: "SessionService"),
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                .product(name: "ClipboardService", package: "Utilities"),
                "DesignSystem",
                "FoundationExtensions",
                "MicroContainer",
                "WeblogRepository",
                "Route"
            ]
        ),
        .target(
            name: "WeblogNetworkService",
            dependencies: [
                "MicroClient",
                "OMGAPI"
            ]
        ),
        .target(
            name: "WeblogPersistenceService",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession")
            ]
        ),
        .target(
            name: "WeblogRepository",
            dependencies: [
                "WeblogNetworkService",
                "WeblogPersistenceService",
                .product(name: "SessionServiceInterface", package: "SessionService"),
                .product(name: "AuthSessionServiceInterface", package: "AuthSession")
            ]
        ),
        .testTarget(
            name: "WeblogTests",
            dependencies: ["Weblog"]
        )
    ]
)

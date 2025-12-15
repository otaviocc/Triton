// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Pastebin",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Pastebin",
            targets: ["Pastebin"]
        )
    ],
    dependencies: [
        .package(
            name: "SessionService",
            path: "../SessionService"
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
            name: "AuthSession",
            path: "../AuthSession"
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
            name: "Pastebin",
            dependencies: [
                .product(name: "SessionServiceInterface", package: "SessionService"),
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                .product(name: "ClipboardService", package: "Utilities"),
                "DesignSystem",
                "FoundationExtensions",
                "MicroContainer",
                "Route",
                "PastebinRepository"
            ]
        ),
        .target(
            name: "PastebinNetworkService",
            dependencies: ["OMGAPI", "MicroClient"]
        ),
        .target(
            name: "PastebinPersistenceService",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession")
            ]
        ),
        .target(
            name: "PastebinRepository",
            dependencies: [
                "PastebinNetworkService",
                "PastebinPersistenceService",
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                .product(name: "SessionServiceInterface", package: "SessionService")
            ]
        ),
        .testTarget(
            name: "PastebinTests",
            dependencies: ["Pastebin"]
        )
    ]
)

// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AccountUpdate",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "AccountUpdateService",
            targets: ["AccountUpdateService"]
        )
    ],
    dependencies: [
        .package(
            name: "SessionService",
            path: "../SessionService"
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
            url: "https://github.com/otaviocc/MicroContainer.git",
            from: "0.0.6"
        ),
        .package(
            url: "https://github.com/apple/swift-async-algorithms",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "AccountUpdateService",
            dependencies: [
                "AccountUpdateNetworkService",
                "AccountUpdatePersistenceService",
                "AccountUpdateRepository",
                "MicroContainer"
            ]
        ),
        .target(
            name: "AccountUpdateNetworkService",
            dependencies: [
                "OMGAPI"
            ]
        ),
        .target(
            name: "AccountUpdatePersistenceService",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                .product(name: "SessionServiceInterface", package: "SessionService")
            ]
        ),
        .target(
            name: "AccountUpdateRepository",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                "AccountUpdateNetworkService",
                "AccountUpdatePersistenceService"
            ]
        )
    ]
)

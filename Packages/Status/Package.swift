// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Status",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Status",
            targets: ["Status"]
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
            url: "https://github.com/otaviocc/MicroClient.git",
            from: "0.0.27"
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
            name: "Status",
            dependencies: [
                .product(name: "SessionServiceInterface", package: "SessionService"),
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                .product(name: "ClipboardService", package: "Utilities"),
                "DesignSystem",
                "MicroContainer",
                "Route",
                "StatusRepository"
            ]
        ),
        .target(
            name: "StatusNetworkService",
            dependencies: ["OMGAPI", "MicroClient"]
        ),
        .testTarget(
            name: "StatusNetworkServiceTests",
            dependencies: ["StatusNetworkService"]
        ),
        .target(
            name: "StatusPersistenceService",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession")
            ]
        ),
        .testTarget(
            name: "StatusPersistenceServiceTests",
            dependencies: ["StatusPersistenceService"]
        ),
        .target(
            name: "StatusRepository",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                "StatusNetworkService",
                "StatusPersistenceService"
            ]
        ),
        .testTarget(
            name: "StatusRepositoryTests",
            dependencies: ["StatusRepository"]
        )
    ]
)

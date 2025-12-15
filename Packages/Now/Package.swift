// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Now",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Now",
            targets: ["Now"]
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
            name: "Now",
            dependencies: [
                .product(name: "SessionServiceInterface", package: "SessionService"),
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                "DesignSystem",
                "MicroContainer",
                "NowRepository",
                "Route"
            ]
        ),
        .target(
            name: "NowNetworkService",
            dependencies: [
                "MicroClient",
                "OMGAPI"
            ]
        ),
        .target(
            name: "NowPersistenceService",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession")
            ]
        ),
        .target(
            name: "NowRepository",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                .product(name: "SessionServiceInterface", package: "SessionService"),
                "NowNetworkService",
                "NowPersistenceService"
            ]
        ),
        .testTarget(
            name: "NowTests",
            dependencies: ["Now"]
        )
    ]
)

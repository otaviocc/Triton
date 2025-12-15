// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Auth",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Auth",
            targets: ["Auth"]
        )
    ],
    dependencies: [
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
            name: "Auth",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                "AuthRepository",
                "DesignSystem",
                "MicroContainer"
            ]
        ),
        .target(
            name: "AuthNetworkService",
            dependencies: ["OMGAPI", "MicroClient"]
        ),
        .testTarget(
            name: "AuthNetworkServiceTests",
            dependencies: ["AuthNetworkService"]
        ),
        .target(
            name: "AuthPersistenceService",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession")
            ]
        ),
        .testTarget(
            name: "AuthPersistenceServiceTests",
            dependencies: ["AuthPersistenceService"]
        ),
        .target(
            name: "AuthRepository",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                "AuthNetworkService",
                "AuthPersistenceService"
            ]
        ),
        .testTarget(
            name: "AuthRepositoryTests",
            dependencies: ["AuthRepository"]
        )
    ]
)

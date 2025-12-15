// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Webpage",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Webpage",
            targets: ["Webpage"]
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
            name: "Webpage",
            dependencies: [
                .product(name: "SessionServiceInterface", package: "SessionService"),
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                "DesignSystem",
                "MicroContainer",
                "WebpageRepository",
                "Route"
            ]
        ),
        .target(
            name: "WebpageNetworkService",
            dependencies: [
                "MicroClient",
                "OMGAPI"
            ]
        ),
        .target(
            name: "WebpagePersistenceService",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession")
            ]
        ),
        .target(
            name: "WebpageRepository",
            dependencies: [
                "WebpageNetworkService",
                "WebpagePersistenceService",
                .product(name: "SessionServiceInterface", package: "SessionService"),
                .product(name: "AuthSessionServiceInterface", package: "AuthSession")
            ]
        ),
        .testTarget(
            name: "WebpageTests",
            dependencies: ["Webpage"]
        )
    ]
)

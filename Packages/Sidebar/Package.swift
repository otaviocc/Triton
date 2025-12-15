// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Sidebar",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Sidebar",
            targets: ["Sidebar"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/otaviocc/MicroContainer.git",
            from: "0.0.6"
        ),
        .package(
            name: "Route",
            path: "../Route"
        ),
        .package(
            name: "AuthSession",
            path: "../AuthSession"
        ),
        .package(
            name: "DesignSystem",
            path: "../DesignSystem"
        )
    ],
    targets: [
        .target(
            name: "Sidebar",
            dependencies: [
                .product(name: "AuthSessionServiceInterface", package: "AuthSession"),
                "DesignSystem",
                "MicroContainer",
                "Route"
            ]
        ),
        .testTarget(
            name: "SidebarTests",
            dependencies: ["Sidebar"]
        )
    ]
)

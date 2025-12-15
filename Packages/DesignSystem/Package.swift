// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        )
    ],
    dependencies: [
        .package(
            name: "FoundationExtensions",
            path: "../FoundationExtensions"
        )
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: ["FoundationExtensions"],
            resources: [
                .copy("Views/EmojiPicker/Data/Emojis.json")
            ]
        )
    ]
)

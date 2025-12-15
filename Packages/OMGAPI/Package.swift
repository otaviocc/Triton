// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "OMGAPI",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "OMGAPI",
            targets: ["OMGAPI"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/otaviocc/MicroClient.git",
            from: "0.0.27"
        ),
        .package(
            name: "FoundationExtensions",
            path: "../FoundationExtensions"
        )
    ],
    targets: [
        .target(
            name: "OMGAPI",
            dependencies: [
                "FoundationExtensions",
                "MicroClient"
            ]
        ),
        .testTarget(
            name: "OMGAPITests",
            dependencies: ["OMGAPI"]
        )
    ]
)

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PartifulApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "PartifulApp",
            targets: ["PartifulApp"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PartifulApp",
            path: "PartifulApp",
            exclude: ["Resources/Info.plist"]
        ),
        .testTarget(
            name: "PartifulAppTests",
            dependencies: ["PartifulApp"],
            path: "PartifulAppTests"
        ),
    ]
)

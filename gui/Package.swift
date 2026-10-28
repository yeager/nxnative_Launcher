// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NXNativeGUI",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "NXNativeGUI", targets: ["NXNativeGUI"])
    ],
    targets: [
        .executableTarget(
            name: "NXNativeGUI",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)

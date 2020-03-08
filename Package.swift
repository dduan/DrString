// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DrString",
    products: [
        .executable(
            name: "drstring-cli",
            targets: ["DrStringCLI"]
        ),
        .library(
            name: "DrString",
            targets: ["DrString"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            .exact("0.50100.0")
        ),
        .package(
            url: "https://github.com/dduan/IsTTY.git",
            .exact("0.1.0")
        ),
        .package(
            url: "https://github.com/dduan/Pathos.git",
            .exact("0.2.1")
        ),
        .package(
            url: "https://github.com/dduan/TOMLDecoder.git",
            .exact("0.1.5")
        ),
        .package(
            url: "https://github.com/mxcl/Chalk.git",
            .exact("0.4.0")
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            .exact("0.0.2")
        ),

        // For testing
        .package(
            url: "https://github.com/llvm-swift/FileCheck.git",
            .exact("0.2.3")
        ),
    ],
    targets: [
        .target(
            name: "Crawler",
            dependencies: [
                "Decipher",
                "Pathos",
                "SwiftSyntax",
            ]
        ),
        .target(
            name: "Critic",
            dependencies: [
                "Crawler",
                "Decipher",
                "Models",
            ]
        ),
        .target(
            name: "Editor",
            dependencies: [
                "Crawler",
                "Decipher",
            ]
        ),
        .target(
            name: "Decipher",
            dependencies: ["Models"]
        ),
        .target(
            name: "Models",
            dependencies: []
        ),
        .target(
            name: "Informant",
            dependencies: [
                "Chalk",
                "Critic",
                "Pathos",
            ]
        ),
        .target(
            name: "DrString",
            dependencies: [
                "ArgumentParser",
                "Critic",
                "Decipher",
                "Editor",
                "Informant",
                "IsTTY",
                "Models",
                "Pathos",
                "TOMLDecoder",
            ]
        ),
        .target(
            name: "DrStringCLI",
            dependencies: ["DrString"]
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: ["Models"]
        ),
        .testTarget(
            name: "CriticTests",
            dependencies: [
                "Critic",
                "Models",
            ]
        ),
        .testTarget(
            name: "EditorTests",
            dependencies: [
                "Editor",
                "Models",
            ]
        ),
        .testTarget(
            name: "DecipherTests",
            dependencies: [
                "Decipher",
                "Models",
            ]
        ),
        .testTarget(
            name: "DrStringTests",
            dependencies: [
                "DrString",
                "FileCheck",
                "Models",
                "Pathos",
            ],
            exclude: ["Tests/DrStringTests/Fixtures"]
        ),
    ]
)

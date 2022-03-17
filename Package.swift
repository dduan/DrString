// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "DrString",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .executable(
            name: "drstring-cli",
            targets: ["DrStringCLI"]
        ),
        .library(
            name: "DrStringCore",
            targets: ["DrStringCore"]
        ),
    ],
    dependencies: [
        .package(
            name: "SwiftSyntax",
            url: "https://github.com/dduan/swift-syntax.git",
            .branch("release/5.6")
        ),
        .package(
            url: "https://github.com/dduan/IsTTY.git",
            .exact("0.1.0")
        ),
        .package(
            url: "https://github.com/dduan/Pathos.git",
            .exact("0.4.2")
        ),
        .package(
            url: "https://github.com/dduan/TOMLDecoder.git",
            .exact("0.2.1")
        ),
        .package(
            url: "https://github.com/mxcl/Chalk.git",
            .exact("0.4.0")
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            .exact("1.1.0")
        ),

        // For testing
        .package(
            url: "https://github.com/llvm-swift/FileCheck.git",
            .exact("0.2.6")
        ),
    ],
    targets: [
        .target(
            name: "Crawler",
            dependencies: [
                "Decipher",
                "Pathos",
                .product(name: "SwiftSyntaxParser", package: "SwiftSyntax"),
                .product(name: "SwiftSyntax", package: "SwiftSyntax"),
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
            name: "DrStringCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
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
        .executableTarget(
            name: "DrStringCLI",
            dependencies: ["DrStringCore"]
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
            name: "DrStringCoreTests",
            dependencies: [
                "DrStringCore",
                "FileCheck",
                "Models",
                "Pathos",
            ],
            exclude: [
                "Fixtures/",
            ]
        ),
    ]
)

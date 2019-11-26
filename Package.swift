// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DrString",
    products: [
        .executable(name: "drstring", targets: ["DrStringCLI"]),
        .library(name: "DrString", targets: [
            "DrString",
            "Crawler",
            "Critic",
            "Editor",
            "Decipher",
            "Informant",
        ]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50100.0")),
        .package(url: "https://github.com/dduan/IsTTY.git", .exact("0.1.0")),
        .package(url: "https://github.com/dduan/Pathos.git", .exact("0.2.1")),
        .package(url: "https://github.com/dduan/TOMLDecoder.git", .exact("0.1.5")),
        .package(url: "https://github.com/mxcl/Chalk.git", .exact("0.4.0")),
        .package(url: "https://github.com/nsomar/Guaka.git", .exact("0.4.1")),

        // For testing
        .package(url: "https://github.com/llvm-swift/FileCheck.git", .exact("0.2.3")),
    ],
    targets: [
        .target(name: "Crawler", dependencies: ["Decipher", "SwiftSyntax", "Pathos"]),
        .target(name: "Critic", dependencies: ["Crawler", "Decipher"]),
        .target(name: "Editor", dependencies: ["Crawler", "Decipher"]),
        .target(name: "Decipher", dependencies: []),
        .target(name: "Informant", dependencies: ["Critic", "Chalk"]),
        .target(name: "DrString", dependencies: ["Editor", "Decipher", "Informant", "Critic", "Pathos", "IsTTY"]),
        .target(name: "DrStringCLI", dependencies: ["DrString", "Pathos", "Guaka", "TOMLDecoder"]),
        .testTarget(name: "CriticTests", dependencies: ["Crawler", "Decipher", "Critic"]),
        .testTarget(name: "EditorTests", dependencies: ["Crawler", "Decipher", "Editor"]),
        .testTarget(name: "DecipherTests", dependencies: ["Decipher"]),
        .testTarget(name: "DrStringTests", dependencies: ["DrString", "FileCheck"],
                    exclude: ["Tests/DrStringTests/Fixtures"]),
    ]
)

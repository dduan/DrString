// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DrString",
    products: [
        .library(
            name: "DrString",
            targets: ["DrString"]),
        .library(
            name: "DrDecipher",
            targets: ["DrDecipher"]),
        .library(
            name: "DrCrawler",
            targets: ["DrCrawler"]),
        .library(
            name: "DrCritic",
            targets: ["DrCritic"]),
        .library(
            name: "DrInformant",
            targets: ["DrInformant"]),
        .executable(
            name: "drstring-cli",
            targets: ["drstring-cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50000.0")),
        .package(url: "https://github.com/nsomar/Guaka.git", .exact("0.4.1")),
        .package(url: "https://github.com/dduan/Pathos.git", .exact("0.2.0")),
    ],
    targets: [
        .target(
            name: "drstring-cli",
            dependencies: ["DrString", "Guaka"]),
        .target(
            name: "DrString",
            dependencies: ["DrInformant", "DrCritic", "Pathos"]),
        .target(
            name: "DrCritic",
            dependencies: ["DrCrawler", "DrDecipher"]),
        .target(
            name: "DrInformant",
            dependencies: ["DrCritic"]),
        .testTarget(
            name: "DrCriticTests",
            dependencies: ["DrCrawler", "DrDecipher", "DrCritic"]),
        .target(
            name: "DrDecipher",
            dependencies: []),
        .target(
            name: "DrCrawler",
            dependencies: ["DrDecipher", "SwiftSyntax"]),
    ]
)

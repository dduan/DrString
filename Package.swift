// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DrString",
    products: [
        .library(
            name: "DrDecipher",
            targets: ["DrDecipher"]),
        .library(
            name: "DrCraweler",
            targets: ["DrCrawler"]),
        .library(
            name: "DrCritic",
            targets: ["DrCritic"]),
        .executable(
            name: "drstring-cli",
            targets: ["drstring-cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten", .exact("0.24.0")),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", .upToNextMinor(from: "4.9.0")),
    ],
    targets: [
        .target(
            name: "drstring-cli",
            dependencies: ["DrCritic", "SourceKittenFramework"]),
        .target(
            name: "DrCritic",
            dependencies: ["DrCrawler"]),
        .target(
            name: "DrDecipher",
            dependencies: []),
        .target(
            name: "DrCrawler",
            dependencies: ["SourceKittenFramework", "SWXMLHash", "DrDecipher"]),
    ]
)

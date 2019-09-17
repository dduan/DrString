// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DrString",
    products: [
        .executable(name: "drstring-cli", targets: ["drstring-cli"]),
        .library(name: "DrCrawler", targets: ["DrCrawler"]),
        .library(name: "DrCritic", targets: ["DrCritic"]),
        .library(name: "DrDecipher", targets: ["DrDecipher"]),
        .library(name: "DrInformant", targets: ["DrInformant"]),
        .library(name: "DrString", targets: ["DrString"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50000.0")),
        .package(url: "https://github.com/dduan/IsTTY.git", .exact("0.1.0")),
        .package(url: "https://github.com/dduan/Pathos.git", .exact("0.2.0")),
        .package(url: "https://github.com/dduan/TOMLDecoder.git", .exact("0.1.4")),
        .package(url: "https://github.com/mxcl/Chalk.git", .exact("0.4.0")),
        .package(url: "https://github.com/nsomar/Guaka.git", .exact("0.4.1")),
    ],
    targets: [
        .target(name: "DrCrawler", dependencies: ["DrDecipher", "SwiftSyntax"]),
        .target(name: "DrCritic", dependencies: ["DrCrawler", "DrDecipher"]),
        .target(name: "DrDecipher", dependencies: []),
        .target(name: "DrInformant", dependencies: ["DrCritic", "Chalk"]),
        .target(name: "DrString", dependencies: ["DrInformant", "DrCritic", "Pathos", "IsTTY"]),
        .target(name: "drstring-cli", dependencies: ["DrString", "Guaka", "TOMLDecoder"]),
        .testTarget(name: "DrCriticTests", dependencies: ["DrCrawler", "DrDecipher", "DrCritic"]),
        .testTarget(name: "DrDecipherTests", dependencies: ["DrDecipher"]),
    ]
)

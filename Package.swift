// swift-tools-version:5.5
import PackageDescription
#if os(macOS)
let magicLibrary = true
#else
let magicLibrary = false
#endif

let package = Package(
    name: "DrString",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(
            name: "drstring",
            targets: ["DrString"]
        ),
        .library(
            name: "DrStringCore",
            targets: ["DrStringCore"]
        ),
    ],
    dependencies: [
        .package(
            name: "SwiftSyntax",
            url: "https://github.com/apple/swift-syntax.git",
            .exact("0.50600.1")
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
            .exact("1.1.1")
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
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "DrStringCore"
            ]
        ),
        .executableTarget(
            name: "DrString",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "DrStringCLI"
            ] + (magicLibrary ? ["lib_InternalSwiftSyntaxParser"] : []),
            linkerSettings: (magicLibrary ? [.unsafeFlags(["-Xlinker", "-dead_strip_dylibs"])] : [])
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
            name: "CLITests",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "DrStringCLI",
            ],
            exclude: ["Fixtures/"]
        ),
        .testTarget(
            name: "DrStringCoreTests",
            dependencies: [
                "DrStringCore",
                "FileCheck",
                "Models",
                "Pathos",
            ],
            exclude: ["Fixtures/"]
        ),
    ] + (magicLibrary ? [.binaryTarget(
        name: "lib_InternalSwiftSyntaxParser",
        url: "https://github.com/keith/StaticInternalSwiftSyntaxParser/releases/download/5.6/lib_InternalSwiftSyntaxParser.xcframework.zip",
        checksum: "88d748f76ec45880a8250438bd68e5d6ba716c8042f520998a438db87083ae9d"
    )] : [])
)

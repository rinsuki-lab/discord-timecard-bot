// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "discord-timecard-bot",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/nuclearace/SwiftDiscord", .revision("5ea8875edf282350c843feb51274122423fd02b5" /* from vapor3 branch */)),
        .package(url: "https://github.com/rinsuki/Hydra", .branch("fix/linux-build-error")),
        .package(url: "https://github.com/rinsuki/swift-sea-api", .revision("8070d3bc4d83ca43dc6658880fa08df3da666131")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "discord-timecard-bot",
            dependencies: ["SwiftDiscord", "Hydra", "SeaAPI"]),
        .testTarget(
            name: "discord-timecard-botTests",
            dependencies: ["discord-timecard-bot"]),
    ]
)

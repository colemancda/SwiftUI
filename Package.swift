// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SwiftUI",
    products: [
        .library(
            name: "SwiftUI",
            targets: ["SwiftUI"]),
        .executable(
            name: "SwiftUIDemo",
            targets: ["SwiftUIDemo"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/PureSwift/SDL.git",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "SwiftUI",
            dependencies: ["SDL"]),
        .target(
            name: "SwiftUIDemo",
            dependencies: ["SwiftUI"])
    ]
)

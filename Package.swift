// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "RxAVFoundation",
    platforms: [
        .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v3)
    ],
    products: [
        .library(
            name: "RxAVFoundation",
            targets: ["RxAVFoundation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "RxAVFoundation",
            dependencies: ["RxSwift", "RxCocoa"]),
        .testTarget(
            name: "RxAVFoundationTests",
            dependencies: ["RxAVFoundation"]),
    ]
)

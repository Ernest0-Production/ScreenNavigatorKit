// swift-tools-version:5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScreenNavigatorKit",
    
    platforms: [.iOS(.v14)],

    products: [
        .library(
            name: "ScreenNavigatorKit",
            targets: ["ScreenNavigatorKit"]
        ),
    ],

    dependencies: [],

    targets: [
        .target(
            name: "ScreenNavigatorKit",
            dependencies: []
        ),

        .testTarget(
            name: "ScreenNavigatorKitTests",
            dependencies: ["ScreenNavigatorKit"]
        ),
    ]
)

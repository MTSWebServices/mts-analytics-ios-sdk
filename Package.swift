// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MTAnalytics",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
         .library(name: "MTAnalytics", targets: ["MTAnalytics"])
    ],
    dependencies: [
      	.package(url: "https://github.com/microsoft/plcrashreporter.git", .upToNextMajor(from: "1.11.0")),
        .package(url: "https://github.com/apple/swift-protobuf.git", .upToNextMajor(from: "1.27.1")),
        .package(url: "https://github.com/groue/GRDB.swift", from: "6.29.3")
    ],
    targets: [
        .binaryTarget(
            name: "MTAnalytics",
            url: "https://packages.a.mts.ru/repository/apple-sdk/ios-sdk/build/MTAnalytics-6.5.1.zip",
            checksum: "f41cde26f06957d82d6a01b9b2d4c2f21c83527e5658689b36630b82f55009ea"
         )
    ]
)

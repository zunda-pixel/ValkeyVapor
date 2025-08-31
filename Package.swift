// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "ValkeyVapor",
  platforms: [
    .macOS(.v15),
    .iOS(.v18),
    .tvOS(.v18),
    .watchOS(.v11),
  ],
  products: [
    .library(
      name: "ValkeyVapor",
      targets: ["ValkeyVapor"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/zunda-pixel/vapor.git", branch: "fix-some-error"),
    .package(url: "https://github.com/valkey-io/valkey-swift.git", from: "0.1.0"),
  ],
  targets: [
    .target(
      name: "ValkeyVapor",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "Valkey", package: "valkey-swift"),
      ]
    ),
    .testTarget(
      name: "ValkeyVaporTests",
      dependencies: ["ValkeyVapor"]
    ),
  ]
)

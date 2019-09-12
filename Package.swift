// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "SwiftyImage",
  platforms: [
    .iOS(.v8), .tvOS(.v9),
  ],
  products: [
    .library(name: "SwiftyImage", targets: ["SwiftyImage"]),
  ],
  targets: [
    .target(name: "SwiftyImage", dependencies: []),
    .testTarget(name: "SwiftyImageTests", dependencies: ["SwiftyImage"]),
  ]
)

// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "unsafe-additions",
  products: [
    .library(
      name: "UnsafeAdditions",
      targets: ["UnsafeAdditions"]
    ),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "UnsafeAdditions",
      dependencies: []
    ),
    .testTarget(
      name: "UnsafeAdditionsTests",
      dependencies: ["UnsafeAdditions"]
    ),
  ]
)


// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SophiaMobileCLI",
    products: [
        .executable(
            name: "SophiaMobileCLI",
            targets: ["SophiaMobileCLI"]
        )
    ],
    targets: [
        .executableTarget(
            name: "SophiaMobileCLI"
        ),
        .testTarget(
            name: "SophiaMobileCLITests",
            dependencies: ["SophiaMobileCLI"]
        ),
        .testTarget(
            name: "SophiaMobileCLIEstudos",
            dependencies: ["SophiaMobileCLI"]
        )
        
    ]
)

// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ConcurrentPersistence",
	platforms: [
		.iOS(.v13)
	],
	products: [
		.library(
			name: "ConcurrentPersistence",
			targets: ["ConcurrentPersistence"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/realm/realm-swift",
			from: "10.28.0"
		)
	],
	targets: [
		.target(
			name: "ConcurrentPersistence",
			dependencies: [
				.product(name: "RealmSwift", package: "realm-swift"),
			],
			path: "Sources/"
		),
		.testTarget(
			name: "ConcurrentPersistenceTests",
			dependencies: [
				"ConcurrentPersistence"
			],
			path: "Tests/"
		),
	],
	swiftLanguageVersions: [.v5]
)

// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ConcurrentDatabase",
	products: [
		.library(
			name: "ConcurrentDatabase",
			targets: ["ConcurrentDatabase"]
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
			name: "ConcurrentDatabase",
			dependencies: []
		),
		.testTarget(
			name: "ConcurrentDatabaseTests",
			dependencies: ["ConcurrentDatabase"]
		),
	]
)

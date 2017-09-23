//
//  Package.swift
//  Log
//
//

import PackageDescription

let package = Package(
	name: "Log",
	targets: [
		Target(name: "Log", dependencies: ["AtomicValue", "Date", "FileSystem", "Optional"]),
		Target(name: "AtomicValue", dependencies: []),
		Target(name: "Date", dependencies: []),
		Target(name: "FileSystem", dependencies: []),
		Target(name: "Optional", dependencies: []),
	]
)


import Foundation
import RealmSwift

public protocol AsyncDatabaseServiceProtocol {
	
	// MARK: - Create
	
	func create<Entity: Object>(
		_ entity: Entity
	) async throws
	
	func create<Entity: Object>(
		_ entities: [Entity]
	) async throws
	
	// MARK: - Read
	
	func read<Entity: Object>(
		_ primaryKey: String
	) async throws -> Entity
	
	func read<Entity: Object>(
		predicate: Predicate
	) async throws -> Entity
	
	func read<Entity: Object>() async throws -> [Entity]
	
	func read<Entity: Object>(
		predicate: Predicate
	) async throws -> [Entity]
	
	func read<Entity: Object>(
		sortDescriptors: [SortDescriptor]
	) async throws -> [Entity]
	
	func read<Entity: Object>(
		predicate: Predicate,
		sortDescriptors: [SortDescriptor]
	) async throws -> [Entity]
	
	// MARK: - Update
	
	func update<Entity: Object>(
		_ primaryKey: String,
		update: @escaping (Entity) -> Void
	) async throws
	
	func update<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void
	) async throws
	
	// MARK: - Delete
	
	@discardableResult
	func delete<Entity: Object>(
		_ primaryKey: String
	) async throws -> Entity
	
	@discardableResult
	func delete<Entity: Object>(
		_ primaryKeys: [String]
	) async throws -> [Entity]
	
	// MARK: - Erase
	
	func erase() async throws
	
}

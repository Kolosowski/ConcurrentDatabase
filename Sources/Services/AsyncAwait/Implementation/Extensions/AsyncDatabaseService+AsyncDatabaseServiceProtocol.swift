import Foundation
import RealmSwift

extension AsyncDatabaseService: AsyncDatabaseServiceProtocol {
	
	// MARK: - Create
	
	func create<Entity: Object>(
		_ entity: Entity
	) async throws {
		
	}
	
	func create<Entity: Object>(
		_ entities: [Entity]
	) async throws {
		
	}
	
	// MARK: - Read
	
	func read<Entity: Object>(
		_ primaryKey: String
	) async throws -> Entity {
		.init()
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate
	) async throws -> Entity {
		.init()
	}
	
	func read<Entity: Object>() async throws -> [Entity] {
		[]
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate
	) async throws -> [Entity] {
		[]
	}
	
	func read<Entity: Object>(
		sortDescriptors: [NSSortDescriptor]
	) async throws -> [Entity] {
		[]
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate,
		sortDescriptors: [NSSortDescriptor]
	) async throws -> [Entity] {
		[]
	}
	
	// MARK: - Update
	
	func update<Entity: Object>(
		_ primaryKey: String,
		update: @escaping (Entity) -> Void
	) async throws {
		
	}
	
	func update<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void
	) async throws {
		
	}
	
	// MARK: - Delete
	
	/**
	 - returns: Invalidated entity.
	 */
	@discardableResult
	func delete<Entity: Object>(
		_ primaryKey: String
	) async throws -> Entity {
		.init()
	}
	
	/**
	 - returns: Array of invalidated entities..
	 */
	@discardableResult
	func delete<Entity: Object>(
		_ primaryKeys: [String]
	) async throws -> [Entity] {
		[]
	}
	
	// MARK: - Erase
	
	func erase() async throws {
		
	}
	
}

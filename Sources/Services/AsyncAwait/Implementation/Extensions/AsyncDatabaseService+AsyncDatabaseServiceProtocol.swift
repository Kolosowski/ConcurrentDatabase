import Foundation
import RealmSwift

extension AsyncDatabaseService: AsyncDatabaseServiceProtocol {
	
	// MARK: - Create
	
	func create<Entity: Object>(
		_ entity: Entity
	) async throws {
		try executer.save([entity])
	}
	
	func create<Entity: Object>(
		_ entities: [Entity]
	) async throws {
		try executer.save(entities)
	}
	
	// MARK: - Read
	
	func read<Entity: Object>(
		_ primaryKey: String
	) async throws -> Entity {
		let entities: [Entity] = try executer.fetch(
			predicate: NSPredicate(format: "\(Entity.primaryKey() ?? "") == %@", primaryKey)
		)
		
		if let entity = entities.first {
			return entity
		} else {
			throw DatabaseError.objectNotFound(primaryKey: primaryKey)
		}
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate
	) async throws -> Entity {
		let entities: [Entity] = try executer.fetch(
			predicate: predicate
		)
		
		if let entity = entities.first {
			return entity
		} else {
			throw DatabaseError.objectNotFound(filter: predicate.predicateFormat)
		}
	}
	
	func read<Entity: Object>() async throws -> [Entity] {
		try executer.fetch()
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate
	) async throws -> [Entity] {
		try executer.fetch(predicate: predicate)
	}
	
	func read<Entity: Object>(
		sortDescriptors: [NSSortDescriptor]
	) async throws -> [Entity] {
		try executer.fetch(sortDescriptors: sortDescriptors)
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate,
		sortDescriptors: [NSSortDescriptor]
	) async throws -> [Entity] {
		try executer.fetch(predicate: predicate, sortDescriptors: sortDescriptors)
	}
	
	// MARK: - Update
	
	func update<Entity: Object>(
		_ primaryKey: String,
		update: @escaping (Entity) -> Void
	) async throws {
		try executer.modify([primaryKey]) { (entities: [Entity]) in
			if let entity = entities.first {
				update(entity)
			}
		}
	}
	
	func update<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void
	) async throws {
		try executer.modify(primaryKeys, update: update)
	}
	
	// MARK: - Delete
	
	/**
	 - returns: Invalidated entity.
	 */
	@discardableResult
	func delete<Entity: Object>(
		_ primaryKey: String
	) async throws -> Entity {
		let entities: [Entity] = try executer.remove([primaryKey])
		
		if let entity = entities.first {
			return entity
		} else {
			throw DatabaseError.objectNotFound(primaryKey: primaryKey)
		}
	}
	
	/**
	 - returns: Array of invalidated entities..
	 */
	@discardableResult
	func delete<Entity: Object>(
		_ primaryKeys: [String]
	) async throws -> [Entity] {
		try executer.remove(primaryKeys)
	}
	
	// MARK: - Erase
	
	func erase() async throws {
		try executer.erase()
	}
	
}

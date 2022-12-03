import Foundation
import RealmSwift

extension AsyncDatabaseService: AsyncDatabaseServiceProtocol {
	
	// MARK: - Create
	
	public func create<Entity: Object>(
		_ entity: Entity
	) async throws {
		try save([entity])
	}
	
	public func create<Entity: Object>(
		_ entities: [Entity]
	) async throws {
		try save(entities)
	}
	
	// MARK: - Read
	
	public func read<Entity: Object>(
		_ primaryKey: String
	) async throws -> Entity {
		let entities: [Entity] = try fetch(
			predicate: Predicate(format: "\(Entity.primaryKey() ?? "") == %@", primaryKey)
		)
		
		if let entity = entities.first {
			return entity
		} else {
			throw Error.objectNotFound(primaryKey: primaryKey)
		}
	}
	
	public func read<Entity: Object>(
		predicate: Predicate
	) async throws -> Entity {
		let entities: [Entity] = try fetch(
			predicate: predicate
		)
		
		if let entity = entities.first {
			return entity
		} else {
			throw Error.objectNotFound(filter: predicate.predicateFormat)
		}
	}
	
	public func read<Entity: Object>() async throws -> [Entity] {
		try fetch()
	}
	
	public func read<Entity: Object>(
		predicate: Predicate
	) async throws -> [Entity] {
		try fetch(predicate: predicate)
	}
	
	public func read<Entity: Object>(
		sortDescriptors: [SortDescriptor]
	) async throws -> [Entity] {
		try fetch(sortDescriptors: sortDescriptors)
	}
	
	public func read<Entity: Object>(
		predicate: Predicate,
		sortDescriptors: [SortDescriptor]
	) async throws -> [Entity] {
		try fetch(predicate: predicate, sortDescriptors: sortDescriptors)
	}
	
	// MARK: - Update
	
	public func update<Entity: Object>(
		_ primaryKey: String,
		update: @escaping (Entity) -> Void
	) async throws {
		try modify([primaryKey]) { (entities: [Entity]) in
			if let entity = entities.first {
				update(entity)
			}
		}
	}
	
	public func update<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void
	) async throws {
		try modify(primaryKeys, update: update)
	}
	
	// MARK: - Delete
	
	/**
	 - returns: Invalidated entity.
	 */
	@discardableResult
	public func delete<Entity: Object>(
		_ primaryKey: String
	) async throws -> Entity {
		let entities: [Entity] = try remove([primaryKey])
		
		if let entity = entities.first {
			return entity
		} else {
			throw Error.objectNotFound(primaryKey: primaryKey)
		}
	}
	
	/**
	 - returns: Array of invalidated entities..
	 */
	@discardableResult
	public func delete<Entity: Object>(
		_ primaryKeys: [String]
	) async throws -> [Entity] {
		try remove(primaryKeys)
	}
	
	// MARK: - Erase
	
	public func erase() async throws {
		try clear()
	}
	
}

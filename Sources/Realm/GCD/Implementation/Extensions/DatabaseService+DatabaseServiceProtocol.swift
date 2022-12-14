import Foundation
import RealmSwift

extension DatabaseService: DatabaseServiceProtocol {
	
	// MARK: - Create
	
	public func create<Entity: Object>(
		_ entity: Entity,
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				try save([entity])
				completion(.success(Void()))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	public func create<Entity: Object>(
		_ entities: [Entity],
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				try save(entities)
				completion(.success(Void()))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	// MARK: - Read
	
	public func read<Entity: Object>(
		_ primaryKey: String,
		completion: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let entities: [Entity] = try fetch(
					predicate: NSPredicate(format: "\(Entity.primaryKey() ?? "") == %@", primaryKey)
				)
				if let entity = entities.first {
					completion(.success(entity))
				} else {
					completion(.failure(Error.objectNotFound(primaryKey: primaryKey)))
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	public func read<Entity: Object>(
		predicate: NSPredicate,
		completion: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let entities: [Entity] = try fetch(
					predicate: predicate
				)
				if let entity = entities.first {
					completion(.success(entity))
				} else {
					completion(.failure(Error.objectNotFound(filter: predicate.predicateFormat)))
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	public func read<Entity: Object>(
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				completion(.success(try fetch()))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	public func read<Entity: Object>(
		predicate: NSPredicate,
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let entities: [Entity] = try fetch(
					predicate: predicate
				)
				completion(.success(entities))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	public func read<Entity: Object>(
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let entities: [Entity] = try fetch(
					sortDescriptors: sortDescriptors
				)
				completion(.success(entities))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	public func read<Entity: Object>(
		predicate: NSPredicate,
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let entities: [Entity] = try fetch(
					predicate: predicate,
					sortDescriptors: sortDescriptors
				)
				completion(.success(entities))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	// MARK: - Update
	
	public func update<Entity: Object>(
		_ primaryKey: String,
		update: @escaping (Entity) -> Void,
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				try modify([primaryKey]) { (entities: [Entity]) in
					if let entity = entities.first {
						update(entity)
						completion(.success(Void()))
					} else {
						completion(.failure(Error.objectNotFound(primaryKey: primaryKey)))
					}
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	public func update<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void,
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				try modify(primaryKeys) { (entities: [Entity]) in
					update(entities)
				}
				completion(.success(Void()))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	// MARK: - Delete
	
	/**
	 - parameter completion: Contains invalidated entity or error if it wasn't deleted.
	 */
	public func delete<Entity: Object>(
		_ primaryKey: String,
		completion: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let entities: [Entity] = try remove([primaryKey])
				if let entity = entities.first {
					completion(.success(entity))
				} else {
					completion(.failure(Error.objectNotFound(primaryKey: primaryKey)))
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	/**
	 - parameter completion: Contains invalidated entities or error if some entities weren't deleted.
	 */
	public func delete<Entity: Object>(
		_ primaryKeys: [String],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let entities: [Entity] = try remove(primaryKeys)
				completion(.success(entities))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	// MARK: - Erase
	
	public func erase(
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				try clear()
				completion(.success(Void()))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
}

import Foundation
import RealmSwift

extension DatabaseService: DatabaseServiceProtocol {
	
	// MARK: - Create
	
	public func create<Entity: Object>(
		_ entity: Entity,
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		save([entity], completion: completion)
	}
	
	public func create<Entity: Object>(
		_ entities: [Entity],
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		save(entities, completion: completion)
	}
	
	// MARK: - Read
	
	public func read<Entity: Object>(
		_ primaryKey: String,
		completion: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		fetch(
			predicate: NSPredicate(format: "\(Entity.primaryKey() ?? "") == %@", primaryKey)
		) { (result: Result<[Entity], Swift.Error>) in
			switch result {
			case .success(let entities):
				if let entity = entities.first {
					completion(.success(entity))
				} else {
					completion(.failure(Error.objectWithKeyNotFound(primaryKey: primaryKey)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	public func read<Entity: Object>(
		predicate: NSPredicate,
		completion: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		fetch(predicate: predicate) { (result: Result<[Entity], Swift.Error>) in
			switch result {
			case .success(let entities):
				if let entity = entities.first {
					completion(.success(entity))
				} else {
					completion(.failure(Error.objectNotFound))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	public func read<Entity: Object>(
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		fetch(completion: completion)
	}
	
	public func read<Entity: Object>(
		predicate: NSPredicate,
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		fetch(
			predicate: predicate,
			completion: completion
		)
	}
	
	public func read<Entity: Object>(
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		fetch(
			sortDescriptors: sortDescriptors,
			completion: completion
		)
	}
	
	public func read<Entity: Object>(
		predicate: NSPredicate,
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		fetch(
			predicate: predicate,
			sortDescriptors: sortDescriptors,
			completion: completion
		)
	}
	
	// MARK: - Update
	
	public func update<Entity: Object>(
		_ primaryKey: String,
		update: @escaping (Entity) -> Void,
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		modify(
			[primaryKey]) { (entities: [Entity]) in
				if let entity = entities.first {
					update(entity)
				} else {
					completion(.failure(Error.objectWithKeyNotFound(primaryKey: primaryKey)))
				}
			} completion: { result in
				completion(result)
			}
	}
	
	public func update<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void,
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		modify(
			primaryKeys,
			update: update,
			completion: completion
		)
	}
	
	// MARK: - Delete
	
	/**
	 - parameter completion: Contains invalidated entity or error if it weren't deleted.
	 */
	public func delete<Entity: Object>(
		_ primaryKey: String,
		completion: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		remove([primaryKey]) { (result: Result<[Entity], Swift.Error>) in
			switch result {
			case .success(let entities):
				if let entity = entities.first {
					completion(.success(entity))
				} else {
					completion(.failure(Error.objectWithKeyNotFound(primaryKey: primaryKey)))
				}
			case .failure(let error):
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
		remove(primaryKeys, completion: completion)
	}
	
	// MARK: - Erase
	
	public func erase(
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let realm = try Realm(configuration: configuration)
				try realm.write {
					realm.deleteAll()
					completion(.success(Void()))
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
}

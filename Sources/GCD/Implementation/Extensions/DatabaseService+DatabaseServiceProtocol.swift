import Foundation
import RealmSwift

extension DatabaseService: DatabaseServiceProtocol {
	
	func create<Entity: Object>(
		_ entities: [Entity],
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let realm = try Realm(configuration: configuration)
				try realm.write {
					realm.add(entities)
				}
				completion(.success(Void()))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate?,
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let realm = try Realm(configuration: configuration)
				var entities = realm.objects(Entity.self)
				if let predicate = predicate {
					entities = entities.filter(predicate)
				}
				sortDescriptors.forEach {
					entities = entities.sorted(byKeyPath: $0.key ?? "", ascending: $0.ascending)
				}
				completion(.success(Array(entities)))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	func update<Entity: Object>(
		_ primaryKey: String,
		block: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let realm = try Realm(configuration: configuration)
				try realm.write {
					if let entity = realm.object(ofType: Entity.self, forPrimaryKey: primaryKey) {
						block(.success(entity))
						realm.add(entity, update: .modified)
					} else {
						block(.failure(Self.Error.objectNotFound(primaryKey: primaryKey)))
					}
				}
			} catch {
				block(.failure(error))
			}
		}
	}
	
	/**
	 - parameter primaryKeys: Array of primary keys related with entities that should be deleted.
	 - parameter completion: Contains invalidated entities or error if some entities weren't deleted.
	 */
	func delete<Entity: Object>(
		_ primaryKeys: [String],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let realm = try Realm(configuration: configuration)
				var deletedEntities: [Entity] = []
				var errors: [Swift.Error] = []
				
				primaryKeys.forEach {
					if let entity = realm.object(ofType: Entity.self, forPrimaryKey: $0), !entity.isInvalidated {
						do {
							try realm.write {
								deletedEntities.append(entity)
								realm.delete(entity)
							}
						} catch {
							errors.append(error)
						}
					} else {
						errors.append(Self.Error.objectNotFound(primaryKey: $0))
					}
				}
				
				if errors.isEmpty {
					completion(.success(deletedEntities))
				} else {
					completion(.failure(Self.Error.fetchMultiple(errors: errors)))
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	func erase(
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

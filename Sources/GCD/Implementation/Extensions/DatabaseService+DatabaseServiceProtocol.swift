import Foundation
import RealmSwift

extension DatabaseService: DatabaseServiceProtocol {
	
	func update<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void,
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		var errors: [Swift.Error] = []
		workQueue.async {
			do {
				let realm = try Realm(configuration: configuration)
				let entities = primaryKeys.compactMap { key -> Entity? in
					if let entity = realm.object(ofType: Entity.self, forPrimaryKey: key) {
						return entity
					} else {
						errors.append(Self.Error.objectNotFound(primaryKey: key))
						return nil
					}
				}
				try realm.write {
					update(entities)
					realm.add(entities, update: .modified)
				}
				if errors.isEmpty {
					completion(.success(Void()))
				} else {
					completion(.failure(Self.Error.fetchMultiple(errors: errors)))
				}
			} catch {
				completion(.failure(error))
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
	
}

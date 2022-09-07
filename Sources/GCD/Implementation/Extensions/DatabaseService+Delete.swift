import Foundation
import RealmSwift

public extension DatabaseService {
	
	/**
	 - parameter completion: Contains invalidated entity or error if it weren't deleted.
	 */
	func delete<Entity: Object>(
		_ primaryKey: String,
		completion: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		remove([primaryKey]) { (result: Result<[Entity], Swift.Error>) in
			if case let Result.failure(error) = result {
				completion(.failure(error))
			} else if case let Result.success(entities) = result, let entity = entities.first {
				completion(.success(entity))
			} else {
				completion(.failure(Error.objectWithKeyNotFound(primaryKey: primaryKey)))
			}
		}
	}
	
	/**
	 - parameter completion: Contains invalidated entities or error if some entities weren't deleted.
	 */
	func delete<Entity: Object>(
		_ primaryKeys: [String],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		remove(primaryKeys, completion: completion)
	}
	
}

private extension DatabaseService {
	
	func remove<Entity: Object>(
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
						errors.append(Error.objectWithKeyNotFound(primaryKey: $0))
					}
				}
				
				if errors.isEmpty {
					completion(.success(deletedEntities))
				} else {
					completion(.failure(Error.fetchMultiple(errors: errors)))
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
}

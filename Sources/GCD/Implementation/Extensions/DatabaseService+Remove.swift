import Foundation
import RealmSwift

extension DatabaseService {
	
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

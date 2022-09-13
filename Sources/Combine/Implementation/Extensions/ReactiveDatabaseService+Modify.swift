import Foundation
import RealmSwift

extension ReactiveDatabaseService {
	
	func modify<Entity: Object>(
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
						errors.append(Error.objectNotFound(primaryKey: key))
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
					completion(.failure(Error.multipleObjectsNotUpdated))
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
}

import Foundation
import RealmSwift

public extension DatabaseService {
	
	func update<Entity: Object>(
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
	
	func update<Entity: Object>(
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
	
}

private extension DatabaseService {
	
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
						errors.append(Error.objectWithKeyNotFound(primaryKey: key))
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
					completion(.failure(Error.fetchMultiple(errors: errors)))
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
}

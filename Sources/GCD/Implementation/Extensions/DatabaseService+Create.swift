import Foundation
import RealmSwift

public extension DatabaseService {
	
	func create<Entity: Object>(
		_ entity: Entity,
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		save([entity], completion: completion)
	}
	
	func create<Entity: Object>(
		_ entities: [Entity],
		completion: @escaping (Result<Void, Swift.Error>) -> Void
	) {
		save(entities, completion: completion)
	}
	
}

private extension DatabaseService {
	
	func save<Entity: Object>(
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
	
}

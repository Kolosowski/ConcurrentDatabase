import Foundation
import RealmSwift

extension DatabaseService {
	
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
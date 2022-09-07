import Foundation
import RealmSwift

extension DatabaseService {
	
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

import Foundation
import RealmSwift

extension AsyncDatabaseService {
	
	func clear() throws {
		let realm = try Realm(configuration: configuration)
		try realm.write {
			realm.deleteAll()
		}
	}
	
}

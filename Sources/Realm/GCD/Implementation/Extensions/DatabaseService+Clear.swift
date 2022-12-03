import Foundation
import RealmSwift

extension DatabaseService {
	
	func clear() throws {
		let realm = try Realm(configuration: configuration)
		try realm.write {
			realm.deleteAll()
		}
	}
	
}

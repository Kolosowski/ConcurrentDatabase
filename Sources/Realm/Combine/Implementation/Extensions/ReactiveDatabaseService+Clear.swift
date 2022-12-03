import Foundation
import RealmSwift

extension ReactiveDatabaseService {
	
	func clear() throws {
		let realm = try Realm(configuration: configuration)
		try realm.write {
			realm.deleteAll()
		}
	}
	
}

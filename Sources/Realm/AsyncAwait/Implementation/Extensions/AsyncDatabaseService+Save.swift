import Foundation
import RealmSwift

extension AsyncDatabaseService {
	
	func save<Entity: Object>(
		_ entities: [Entity]
	) throws {
		let realm = try Realm(configuration: configuration)
		try realm.write {
			realm.add(entities)
		}
	}
	
}

import Foundation
import RealmSwift

extension AsyncDatabaseService {
	
	func modify<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void
	) throws {
		let realm = try Realm(configuration: configuration)
		
		var entities: [Entity] = []
		for primaryKey in primaryKeys {
			if let entity = realm.object(ofType: Entity.self, forPrimaryKey: primaryKey) {
				entities.append(entity)
			} else {
				throw Error.objectNotFound(primaryKey: primaryKey)
			}
		}
		
		try realm.write {
			update(entities)
			realm.add(entities, update: .modified)
		}
	}
	
}

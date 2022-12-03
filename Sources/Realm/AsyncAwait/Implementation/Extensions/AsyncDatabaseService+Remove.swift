import Foundation
import RealmSwift

extension AsyncDatabaseService {
	
	func remove<Entity: Object>(
		_ primaryKeys: [String]
	) throws -> [Entity] {
		let realm = try Realm(configuration: configuration)
		
		var deletedEntities: [Entity] = []
		for primaryKey in primaryKeys {
			if let entity = realm.object(ofType: Entity.self, forPrimaryKey: primaryKey), !entity.isInvalidated {
				try realm.write {
					deletedEntities.append(entity)
					realm.delete(entity)
				}
			} else {
				throw Error.objectNotFound(primaryKey: primaryKey)
			}
		}
		
		return deletedEntities
	}
	
}

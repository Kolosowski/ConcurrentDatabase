import Foundation
import RealmSwift

extension DatabaseExecuter {
	
	func save<Entity: Object>(
		_ entities: [Entity]
	) throws {
		let realm = try Realm(configuration: configuration)
		try realm.write {
			realm.add(entities)
		}
	}
	
	func fetch<Entity: Object>(
		predicate: NSPredicate? = nil,
		sortDescriptors: [NSSortDescriptor] = []
	) throws -> [Entity] {
		let realm = try Realm(configuration: configuration)
		
		var entities = realm.objects(Entity.self)
		if let predicate = predicate {
			entities = entities.filter(predicate)
		}
		sortDescriptors.forEach {
			entities = entities.sorted(byKeyPath: $0.key ?? "", ascending: $0.ascending)
		}
		
		return Array(entities)
	}
	
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
	
	@discardableResult
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
	
	func erase() throws {
		let realm = try Realm(configuration: configuration)
		try realm.write {
			realm.deleteAll()
		}
	}
	
}

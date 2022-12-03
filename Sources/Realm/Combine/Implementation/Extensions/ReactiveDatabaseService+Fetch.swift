import Foundation
import RealmSwift

extension ReactiveDatabaseService {
	
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
	
}

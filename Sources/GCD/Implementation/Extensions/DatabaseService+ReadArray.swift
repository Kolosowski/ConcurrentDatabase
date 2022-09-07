import Foundation
import RealmSwift

extension DatabaseService {
	
	func read<Entity: Object>(
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		fetch(completion: completion)
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate?,
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		fetch(
			predicate: predicate,
			completion: completion
		)
	}
	
	func read<Entity: Object>(
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		fetch(
			sortDescriptors: sortDescriptors,
			completion: completion
		)
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate?,
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		fetch(
			predicate: predicate,
			sortDescriptors: sortDescriptors,
			completion: completion
		)
	}
	
}

private extension DatabaseService {
	
	func fetch<Entity: Object>(
		predicate: NSPredicate? = nil,
		sortDescriptors: [NSSortDescriptor] = [],
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		workQueue.async {
			do {
				let realm = try Realm(configuration: configuration)
				var entities = realm.objects(Entity.self)
				if let predicate = predicate {
					entities = entities.filter(predicate)
				}
				sortDescriptors.forEach {
					entities = entities.sorted(byKeyPath: $0.key ?? "", ascending: $0.ascending)
				}
				completion(.success(Array(entities)))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
}

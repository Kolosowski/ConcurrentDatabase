import Foundation
import RealmSwift

public extension DatabaseService {
	
	func read<Entity: Object>(
		_ primaryKey: String,
		completion: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		fetch(
			predicate: NSPredicate(format: "\(Entity.primaryKey() ?? "") == %@", primaryKey)
		) { (result: Result<[Entity], Swift.Error>) in
			if case let Result.failure(error) = result {
				completion(.failure(error))
			} else if case let Result.success(entities) = result, let entity = entities.first {
				completion(.success(entity))
			} else {
				completion(.failure(Error.objectWithKeyNotFound(primaryKey: primaryKey)))
			}
		}
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate,
		completion: @escaping (Result<Entity, Swift.Error>) -> Void
	) {
		fetch(predicate: predicate) { (result: Result<[Entity], Swift.Error>) in
			if case let Result.failure(error) = result {
				completion(.failure(error))
			} else if case let Result.success(entities) = result, let entity = entities.first {
				completion(.success(entity))
			} else {
				completion(.failure(Error.objectNotFound))
			}
		}
	}
	
	func read<Entity: Object>(
		completion: @escaping (Result<[Entity], Swift.Error>) -> Void
	) {
		fetch(completion: completion)
	}
	
	func read<Entity: Object>(
		predicate: NSPredicate,
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
		predicate: NSPredicate,
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

import Foundation
import Combine
import RealmSwift

public protocol ReactiveDatabaseServiceProtocol {
	
	// MARK: - Create
	
	func create<Entity: Object>(
		_ entity: Entity
	) -> AnyPublisher<Void, Error>
	
	func create<Entity: Object>(
		_ entities: [Entity]
	) -> AnyPublisher<Void, Error>
	
	// MARK: - Read
	
	func read<Entity: Object>(
		_ primaryKey: String
	) -> AnyPublisher<Entity, Error>
	
	func read<Entity: Object>(
		predicate: NSPredicate
	) -> AnyPublisher<Entity, Error>
	
	func read<Entity: Object>() -> AnyPublisher<[Entity], Error>
	
	func read<Entity: Object>(
		predicate: NSPredicate
	) -> AnyPublisher<[Entity], Error>
	
	func read<Entity: Object>(
		sortDescriptors: [NSSortDescriptor]
	) -> AnyPublisher<[Entity], Error>
	
	func read<Entity: Object>(
		predicate: NSPredicate,
		sortDescriptors: [NSSortDescriptor]
	) -> AnyPublisher<[Entity], Error>
	
}

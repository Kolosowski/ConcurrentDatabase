import Foundation
import Combine
import RealmSwift

public protocol ReactiveDatabaseServiceProtocol {
	
	// MARK: - Create
	
	func createPublisher<Entity: Object>(
		_ entity: Entity
	) -> AnyPublisher<Void, Error>
	
	func createPublisher<Entity: Object>(
		_ entities: [Entity]
	) -> AnyPublisher<Void, Error>
	
	// MARK: - Read
	
	func readPublisher<Entity: Object>(
		_ primaryKey: String
	) -> AnyPublisher<Entity, Error>
	
	func readPublisher<Entity: Object>(
		predicate: NSPredicate
	) -> AnyPublisher<Entity, Error>
	
	func readPublisher<Entity: Object>() -> AnyPublisher<[Entity], Error>
	
	func readPublisher<Entity: Object>(
		predicate: NSPredicate
	) -> AnyPublisher<[Entity], Error>
	
	func readPublisher<Entity: Object>(
		sortDescriptors: [NSSortDescriptor]
	) -> AnyPublisher<[Entity], Error>
	
	func readPublisher<Entity: Object>(
		predicate: NSPredicate,
		sortDescriptors: [NSSortDescriptor]
	) -> AnyPublisher<[Entity], Error>
	
	// MARK: - Update
	
	func updatePublisher<Entity: Object>(
		_ primaryKey: String,
		update: @escaping (Entity) -> Void
	) -> AnyPublisher<Void, Error>
	
	func updatePublisher<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void
	) -> AnyPublisher<Void, Error>
	
	// MARK: - Delete
	
	func delete<Entity: Object>(
		_ primaryKey: String
	) -> AnyPublisher<Entity, Error>
	
	func delete<Entity: Object>(
		_ primaryKeys: [String]
	) -> AnyPublisher<[Entity], Error>
	
	// MARK: - Erase
	
	var erasePublisher: AnyPublisher<Void, Error> { get }
	
}

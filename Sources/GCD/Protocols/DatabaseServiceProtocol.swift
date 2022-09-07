import Foundation
import RealmSwift

protocol DatabaseServiceProtocol {
	
	// MARK: - Create
	
	func create<Entity: Object>(
		_ entity: Entity,
		completion: @escaping (Result<Void, Error>) -> Void
	)
	
	func create<Entity: Object>(
		_ entities: [Entity],
		completion: @escaping (Result<Void, Error>) -> Void
	)
	
	// MARK: - Read Sequence
	
	func read<Entity: Object>(
		completion: @escaping (Result<[Entity], Error>) -> Void
	)
	
	func read<Entity: Object>(
		predicate: NSPredicate?,
		completion: @escaping (Result<[Entity], Error>) -> Void
	)
	
	func read<Entity: Object>(
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Error>) -> Void
	)
	
	func read<Entity: Object>(
		predicate: NSPredicate?,
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Error>) -> Void
	)
	
	// MARK: - Update
	
	func update<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void,
		completion: @escaping (Result<Void, Error>) -> Void
	)
	
	// MARK: - Delete
	
	func delete<Entity: Object>(
		_ primaryKey: String,
		completion: @escaping (Result<Entity, Error>) -> Void
	)
	
	func delete<Entity: Object>(
		_ primaryKeys: [String],
		completion: @escaping (Result<[Entity], Error>) -> Void
	)
	
	// MARK: - Erase
	
	func erase(
		completion: @escaping (Result<Void, Error>) -> Void
	)
	
}

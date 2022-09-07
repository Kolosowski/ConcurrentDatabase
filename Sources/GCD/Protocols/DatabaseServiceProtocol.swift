import Foundation
import RealmSwift

protocol DatabaseServiceProtocol {
	
	func create<Entity: Object>(
		_ entities: [Entity],
		completion: @escaping (Result<Void, Error>) -> Void
	)
	
	func read<Entity: Object>(
		predicate: NSPredicate?,
		sortDescriptors: [NSSortDescriptor],
		completion: @escaping (Result<[Entity], Error>) -> Void
	)
	
	func update<Entity: Object>(
		_ primaryKey: String,
		block: @escaping (Result<Entity, Error>) -> Void
	)
	
	func delete<Entity: Object>(
		_ primaryKeys: [String],
		completion: @escaping (Result<[Entity], Error>) -> Void
	)
	
	func deleteAll(
		completion: @escaping (Result<Void, Error>) -> Void
	)
	
}

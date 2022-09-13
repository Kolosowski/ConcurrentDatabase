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
	
}

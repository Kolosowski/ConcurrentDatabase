import Foundation
import Combine
import RealmSwift

extension ReactiveDatabaseService: ReactiveDatabaseServiceProtocol {
	
	// MARK: - Create
	
	public func create<Entity: Object>(
		_ entity: Entity
	) -> AnyPublisher<Void, Error> {
		Deferred {
			Future<Void, Error> { promise in
				self.save([entity]) { result in
					switch result {
					case .success:
						promise(.success(Void()))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	public func create<Entity: Object>(
		_ entities: [Entity]
	) -> AnyPublisher<Void, Error> {
		Deferred {
			Future<Void, Error> { promise in
				self.save(entities) { result in
					switch result {
					case .success:
						promise(.success(Void()))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
}

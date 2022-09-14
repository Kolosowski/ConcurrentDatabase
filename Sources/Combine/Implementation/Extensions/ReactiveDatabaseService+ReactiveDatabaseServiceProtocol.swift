import Foundation
import Combine
import RealmSwift

extension ReactiveDatabaseService: ReactiveDatabaseServiceProtocol {
	
	// MARK: - Create
	
	public func createPublisher<Entity: Object>(
		_ entity: Entity
	) -> AnyPublisher<Void, Swift.Error> {
		Deferred {
			Future { promise in
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
	
	public func createPublisher<Entity: Object>(
		_ entities: [Entity]
	) -> AnyPublisher<Void, Swift.Error> {
		Deferred {
			Future { promise in
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
	
	// MARK: - Read
	
	public func readPublisher<Entity: Object>(
		_ primaryKey: String
	) -> AnyPublisher<Entity, Swift.Error> {
		Deferred {
			Future { promise in
				self.fetch(
					predicate: NSPredicate(format: "\(Entity.primaryKey() ?? "") == %@", primaryKey)
				) { (result: Result<[Entity], Swift.Error>) in
					switch result {
					case .success(let entities):
						guard let entity = entities.first else {
							promise(.failure(Error.objectNotFound(primaryKey: primaryKey)))
							return
						}
						promise(.success(entity))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	public func readPublisher<Entity: Object>(
		predicate: NSPredicate
	) -> AnyPublisher<Entity, Swift.Error> {
		Deferred {
			Future { promise in
				self.fetch(predicate: predicate) { (result: Result<[Entity], Swift.Error>) in
					switch result {
					case .success(let entities):
						guard let entity = entities.first else {
							promise(.failure(Error.objectNotFound(filter: predicate.predicateFormat)))
							return
						}
						promise(.success(entity))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	public func readPublisher<Entity: Object>() -> AnyPublisher<[Entity], Swift.Error> {
		Deferred {
			Future { promise in
				self.fetch { (result: Result<[Entity], Swift.Error>) in
					switch result {
					case .success(let entities):
						promise(.success(entities))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	public func readPublisher<Entity: Object>(
		predicate: NSPredicate
	) -> AnyPublisher<[Entity], Swift.Error> {
		Deferred {
			Future { promise in
				self.fetch(
					predicate: predicate
				) { (result: Result<[Entity], Swift.Error>) in
					switch result {
					case .success(let entities):
						promise(.success(entities))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	public func readPublisher<Entity: Object>(
		sortDescriptors: [NSSortDescriptor]
	) -> AnyPublisher<[Entity], Swift.Error> {
		Deferred {
			Future { promise in
				self.fetch(
					sortDescriptors: sortDescriptors
				) { (result: Result<[Entity], Swift.Error>) in
					switch result {
					case .success(let entities):
						promise(.success(entities))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	public func readPublisher<Entity: Object>(
		predicate: NSPredicate,
		sortDescriptors: [NSSortDescriptor]
	) -> AnyPublisher<[Entity], Swift.Error> {
		Deferred {
			Future { promise in
				self.fetch(
					predicate: predicate,
					sortDescriptors: sortDescriptors
				) { (result: Result<[Entity], Swift.Error>) in
					switch result {
					case .success(let entities):
						promise(.success(entities))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	// MARK: - Update
	
	public func update<Entity: Object>(
		_ primaryKey: String,
		update: @escaping (Entity) -> Void
	) -> AnyPublisher<Void, Swift.Error> {
		Deferred {
			Future { promise in
				self.modify([primaryKey]) { (entities: [Entity]) in
					if let entity = entities.first {
						update(entity)
					} else {
						promise(.failure(Error.objectNotFound(primaryKey: primaryKey)))
					}
				} completion: { result in
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
	
	public func update<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void
	) -> AnyPublisher<Void, Swift.Error> {
		Deferred {
			Future { promise in
				self.modify(primaryKeys, update: update) { result in
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
	
	// MARK: - Delete
	
	public func delete<Entity: Object>(
		_ primaryKey: String
	) -> AnyPublisher<Entity, Swift.Error> {
		Deferred {
			Future { promise in
				self.remove([primaryKey]) { (result: Result<[Entity], Swift.Error>) in
					switch result {
					case .success(let entities):
						guard let entity = entities.first else {
							promise(.failure(Error.objectNotFound(primaryKey: primaryKey)))
							return
						}
						promise(.success(entity))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	public func delete<Entity: Object>(
		_ primaryKeys: [String]
	) -> AnyPublisher<[Entity], Swift.Error> {
		Deferred {
			Future { promise in
				self.remove(primaryKeys) { (result: Result<[Entity], Swift.Error>) in
					switch result {
					case .success(let entities):
						promise(.success(entities))
					case .failure(let error):
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	// MARK: - Erase
	
	public var erasePublisher: AnyPublisher<Void, Swift.Error> {
		Deferred {
			Future { promise in
				workQueue.async {
					do {
						let realm = try Realm(configuration: configuration)
						try realm.write {
							realm.deleteAll()
							promise(.success(Void()))
						}
					} catch {
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
}

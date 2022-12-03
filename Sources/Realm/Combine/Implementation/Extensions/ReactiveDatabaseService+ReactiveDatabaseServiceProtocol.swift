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
				workQueue.async {
					do {
						try save([entity])
						promise(.success(Void()))
					} catch {
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
				workQueue.async {
					do {
						try save(entities)
						promise(.success(Void()))
					} catch {
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
				workQueue.async {
					do {
						let entities: [Entity] = try fetch(
							predicate: NSPredicate(format: "\(Entity.primaryKey() ?? "") == %@", primaryKey)
						)
						if let entity = entities.first {
							promise(.success(entity))
						} else {
							promise(.failure(Error.objectNotFound(primaryKey: primaryKey)))
						}
					} catch {
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
				workQueue.async {
					do {
						let entities: [Entity] = try fetch(
							predicate: predicate
						)
						if let entity = entities.first {
							promise(.success(entity))
						} else {
							promise(.failure(Error.objectNotFound(filter: predicate.predicateFormat)))
						}
					} catch {
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	public func readPublisher<Entity: Object>() -> AnyPublisher<[Entity], Swift.Error> {
		Deferred {
			Future { promise in
				workQueue.async {
					do {
						promise(.success(try fetch()))
					} catch {
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
				workQueue.async {
					do {
						let entities: [Entity] = try fetch(
							predicate: predicate
						)
						promise(.success(entities))
					} catch {
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
				workQueue.async {
					do {
						let entities: [Entity] = try fetch(
							sortDescriptors: sortDescriptors
						)
						promise(.success(entities))
					} catch {
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
				workQueue.async {
					do {
						let entities: [Entity] = try fetch(
							predicate: predicate,
							sortDescriptors: sortDescriptors
						)
						promise(.success(entities))
					} catch {
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	// MARK: - Update
	
	public func updatePublisher<Entity: Object>(
		_ primaryKey: String,
		update: @escaping (Entity) -> Void
	) -> AnyPublisher<Void, Swift.Error> {
		Deferred {
			Future { promise in
				workQueue.async {
					do {
						try modify([primaryKey]) { (entities: [Entity]) in
							if let entity = entities.first {
								update(entity)
								promise(.success(Void()))
							} else {
								promise(.failure(Error.objectNotFound(primaryKey: primaryKey)))
							}
						}
					} catch {
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	public func updatePublisher<Entity: Object>(
		_ primaryKeys: [String],
		update: @escaping ([Entity]) -> Void
	) -> AnyPublisher<Void, Swift.Error> {
		Deferred {
			Future { promise in
				workQueue.async {
					do {
						try modify(primaryKeys) { (entities: [Entity]) in
							update(entities)
						}
						promise(.success(Void()))
					} catch {
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	// MARK: - Delete
	
	/**
	 - returns: Publisher which contains invalidated entity or error if it wasn't deleted.
	 */
	public func deletePublisher<Entity: Object>(
		_ primaryKey: String
	) -> AnyPublisher<Entity, Swift.Error> {
		Deferred {
			Future { promise in
				workQueue.async {
					do {
						let entities: [Entity] = try remove([primaryKey])
						if let entity = entities.first {
							promise(.success(entity))
						} else {
							promise(.failure(Error.objectNotFound(primaryKey: primaryKey)))
						}
					} catch {
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
	/**
	 - returns: Publisher which contains invalidated entities or error if some entities weren't deleted.
	 */
	public func deletePublisher<Entity: Object>(
		_ primaryKeys: [String]
	) -> AnyPublisher<[Entity], Swift.Error> {
		Deferred {
			Future { promise in
				workQueue.async {
					do {
						let entities: [Entity] = try remove(primaryKeys)
						promise(.success(entities))
					} catch {
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
						try clear()
						promise(.success(Void()))
					} catch {
						promise(.failure(error))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
	
}

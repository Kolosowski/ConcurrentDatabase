import XCTest
import Combine
import RealmSwift
@testable import ConcurrentDatabase

final class ReactiveDatabaseServiceTestCase: XCTestCase {
	
	// MARK: - Stored Properties - Combine
	
	private var cancellables: [AnyCancellable] = []
	
	// MARK: - Stored Properties - Service
	
	private let database: ReactiveDatabaseServiceProtocol = ReactiveDatabaseService(
		configuration: Realm.Configuration(
			inMemoryIdentifier: "inMemory"
		)
	)
	
	// MARK: - Life Cycle
	
	override func tearDown() {
		database
			.erasePublisher
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in }
			.store(in: &cancellables)
		cancellables.removeAll()
	}
	
	// MARK: - Read Tests
	
	func testRead() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntity = MockEntity()
		
		// When
		database
			.createPublisher(newEntity)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				createExpectation.fulfill()
			}
			.store(in: &cancellables)
		
		// Then
		database
			.readPublisher(newEntity.id)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { (storedObject: MockEntity) in
				XCTAssertEqual(storedObject.id, newEntity.id)
				readExpectation.fulfill()
			}
			.store(in: &cancellables)
		wait(for: [createExpectation, readExpectation], timeout: 3)
	}
	
	func testReadWithPredicate() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { value -> MockEntity in
			let mock = MockEntity()
			mock.testValue = value
			return mock
		}
		
		// When
		database
			.createPublisher(newEntities)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				createExpectation.fulfill()
			}
			.store(in: &cancellables)
		
		// Then
		let filterValue = 3
		database
			.readPublisher(
				predicate: NSPredicate(format: "testValue == %d", filterValue)
			)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { (storedObject: MockEntity) in
				XCTAssertEqual(storedObject.testValue, filterValue)
				readExpectation.fulfill()
			}
			.store(in: &cancellables)
		wait(for: [createExpectation, readExpectation], timeout: 2)
	}
	
	func testReadSequence() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { _ in
			MockEntity()
		}
		
		// When
		database
			.createPublisher(newEntities)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				createExpectation.fulfill()
			}
			.store(in: &cancellables)
		
		// Then
		database
			.readPublisher()
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { (storedObjects: [MockEntity]) in
				XCTAssertEqual(storedObjects.count, newEntities.count)
				readExpectation.fulfill()
			}
			.store(in: &cancellables)
		wait(for: [createExpectation, readExpectation], timeout: 3)
	}
	
	func testReadSequenceWithPredicate() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { value -> MockEntity in
			let mock = MockEntity()
			mock.testValue = value
			return mock
		}
		
		// When
		database
			.createPublisher(newEntities)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				createExpectation.fulfill()
			}
			.store(in: &cancellables)
		
		// Then
		database
			.readPublisher(
				predicate: NSPredicate(format: "testValue == 2 OR testValue == 4")
			)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { (storedObjects: [MockEntity]) in
				XCTAssertNotEqual(storedObjects.count, newEntities.count)
				XCTAssertEqual(storedObjects.first?.testValue, 2)
				XCTAssertEqual(storedObjects.last?.testValue, 4)
				readExpectation.fulfill()
			}
			.store(in: &cancellables)
		wait(for: [createExpectation, readExpectation], timeout: 2)
	}
	
	func testReadSequenceWithSort() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { value -> MockEntity in
			let mock = MockEntity()
			mock.testValue = value
			return mock
		}
		
		// When
		database
			.createPublisher(newEntities)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				createExpectation.fulfill()
			}
			.store(in: &cancellables)
		
		// Then
		database
			.readPublisher(
				sortDescriptors: [NSSortDescriptor(key: "testValue", ascending: false)]
			)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { (storedObjects: [MockEntity]) in
				XCTAssertEqual(storedObjects.first?.testValue, 10)
				XCTAssertEqual(storedObjects.last?.testValue, 0)
				readExpectation.fulfill()
			}
			.store(in: &cancellables)
		wait(for: [createExpectation, readExpectation], timeout: 2)
	}
	
	func testReadSequenceWithPredicateAndSort() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { value -> MockEntity in
			let mock = MockEntity()
			mock.testValue = value
			return mock
		}
		
		// When
		database
			.createPublisher(newEntities)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				createExpectation.fulfill()
			}
			.store(in: &cancellables)
		
		// Then
		database
			.readPublisher(
				predicate: NSPredicate(format: "testValue == 2 OR testValue == 4"),
				sortDescriptors: [NSSortDescriptor(key: "testValue", ascending: false)]
			)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { (storedObjects: [MockEntity]) in
				XCTAssertNotEqual(storedObjects.count, newEntities.count)
				XCTAssertEqual(storedObjects.first?.testValue, 4)
				XCTAssertEqual(storedObjects.last?.testValue, 2)
				readExpectation.fulfill()
			}
			.store(in: &cancellables)
		wait(for: [createExpectation, readExpectation], timeout: 2)
	}
	
	// MARK: - Update Tests
	
	func testUpdate() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let updateExpectation = XCTestExpectation(description: "update")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntity = MockEntity()
		let newEntityValue = 10
		newEntity.testValue = newEntityValue
		
		// When
		database
			.createPublisher(newEntity)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				createExpectation.fulfill()
			}
			.store(in: &cancellables)
		let updatedEntityValue = newEntityValue + 100
		database
			.updatePublisher(newEntity.id) { (entity: MockEntity) in
				entity.testValue = updatedEntityValue
			}
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				updateExpectation.fulfill()
			}
			.store(in: &cancellables)
		
		// Then
		database
			.readPublisher(newEntity.id)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { (storedObject: MockEntity) in
				XCTAssertEqual(storedObject.id, newEntity.id)
				XCTAssertEqual(storedObject.testValue, updatedEntityValue)
				readExpectation.fulfill()
			}
			.store(in: &cancellables)
		wait(for: [createExpectation, updateExpectation, readExpectation], timeout: 2)
	}
	
	func testUpdateSequence() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let updateExpectation = XCTestExpectation(description: "update")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntity = MockEntity()
		let newEntityValue = 10
		newEntity.testValue = newEntityValue
		
		// When
		database
			.createPublisher(newEntity)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				createExpectation.fulfill()
			}
			.store(in: &cancellables)
		let updatedEntityValue = newEntityValue + 100
		database
			.updatePublisher([newEntity.id]) { (entities: [MockEntity]) in
				entities
					.first {
						$0.id == newEntity.id
					}?
					.testValue = updatedEntityValue
			}
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				updateExpectation.fulfill()
			}
			.store(in: &cancellables)
		
		// Then
		database
			.readPublisher(newEntity.id)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { (storedObject: MockEntity) in
				XCTAssertEqual(storedObject.id, newEntity.id)
				XCTAssertEqual(storedObject.testValue, updatedEntityValue)
				readExpectation.fulfill()
			}
			.store(in: &cancellables)
		wait(for: [createExpectation, updateExpectation, readExpectation], timeout: 2)
	}
	
	func testUpdate_notExistedEntity() {
		let updateExpectation = XCTestExpectation(description: "update")
		
		database
			.updatePublisher(UUID().uuidString) { (_: MockEntity) in }
			.sink { completion in
				if case let Subscribers.Completion.failure(error) = completion, error is ReactiveDatabaseService.Error {
					XCTAssertTrue(true)
					updateExpectation.fulfill()
				} else {
					XCTFail()
				}
			} receiveValue: { _ in }
			.store(in: &cancellables)
		wait(for: [updateExpectation], timeout: 2)
	}
	
	// MARK: - Erase Tests
	
	func testErase() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let deleteExpectation = XCTestExpectation(description: "delete")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { _ in
			MockEntity()
		}
		
		// When
		database
			.createPublisher(newEntities)
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				createExpectation.fulfill()
			}
			.store(in: &cancellables)
		database
			.erasePublisher
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in
				deleteExpectation.fulfill()
			}
			.store(in: &cancellables)
		
		// Then
		database
			.readPublisher()
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { (storedObjects: [MockEntity]) in
				XCTAssert(storedObjects.isEmpty)
				readExpectation.fulfill()
			}
			.store(in: &cancellables)
		wait(for: [createExpectation, deleteExpectation, readExpectation], timeout: 2)
	}
	
}

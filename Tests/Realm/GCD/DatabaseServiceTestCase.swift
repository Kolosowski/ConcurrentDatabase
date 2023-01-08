import XCTest
import RealmSwift
@testable import ConcurrentPersistence

final class DatabaseServiceTestCase: XCTestCase {
	
	// MARK: - Stored Properties - Service
	
	private let database: DatabaseServiceProtocol = DatabaseService(
		configuration: Realm.Configuration(
			inMemoryIdentifier: "inMemory"
		)
	)
	
	// MARK: - Life Cycle
	
	override func tearDown() {
		database.erase { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
		}
	}
	
	// MARK: - Read Tests
	
	func testRead() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntity = MockEntity()
		
		// When
		database.create(newEntity) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		
		// Then
		database.read(newEntity.id) { (result: Result<MockEntity, Error>) in
			switch result {
			case .success(let storedObject):
				XCTAssertEqual(storedObject.id, newEntity.id)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
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
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		
		// Then
		database.read(
			predicate: NSPredicate(format: "testValue == %d", 3)
		) { (result: Result<MockEntity, Error>) in
			switch result {
			case .success(let storedObject):
				XCTAssertEqual(storedObject.testValue, 3)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
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
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		
		// Then
		database.read { (result: Result<[MockEntity], Error>) in
			switch result {
			case .success(let storedObjects):
				XCTAssertEqual(storedObjects.count, newEntities.count)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
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
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		
		// Then
		database.read(
			predicate: NSPredicate(format: "testValue == %d OR testValue == %d", 2, 4)
		) { (result: Result<[MockEntity], Error>) in
			switch result {
			case .success(let storedObjects):
				XCTAssertNotEqual(storedObjects.count, newEntities.count)
				XCTAssertEqual(storedObjects.first?.testValue, 2)
				XCTAssertEqual(storedObjects.last?.testValue, 4)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
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
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		
		// Then
		database.read(
			sortDescriptors: [NSSortDescriptor(key: "testValue", ascending: false)]
		) { (result: Result<[MockEntity], Error>) in
			switch result {
			case .success(let storedObjects):
				XCTAssertEqual(storedObjects.first?.testValue, 10)
				XCTAssertEqual(storedObjects.last?.testValue, 0)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
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
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		
		// Then
		database.read(
			predicate: NSPredicate(format: "testValue == %d OR testValue == %d", 2, 4),
			sortDescriptors: [NSSortDescriptor(key: "testValue", ascending: false)]
		) { (result: Result<[MockEntity], Error>) in
			switch result {
			case .success(let storedObjects):
				XCTAssertNotEqual(storedObjects.count, newEntities.count)
				XCTAssertEqual(storedObjects.first?.testValue, 4)
				XCTAssertEqual(storedObjects.last?.testValue, 2)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
		wait(for: [createExpectation, readExpectation], timeout: 2)
	}
	
	// MARK: - Update Tests
	
	func testUpdate() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let updateExpectation = XCTestExpectation(description: "update")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntity = {
			let mock = MockEntity()
			mock.testValue = 10
			return mock
		}()
		
		// When
		database.create(newEntity) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		database.update(newEntity.id) { (entity: MockEntity) in
			entity.testValue = 1000
			updateExpectation.fulfill()
		} completion: { _ in }
		
		// Then
		database.read(newEntity.id) { (result: Result<MockEntity, Error>) in
			switch result {
			case .success(let storedObject):
				XCTAssertEqual(storedObject.testValue, 1000)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
		wait(for: [createExpectation, updateExpectation, readExpectation], timeout: 2)
	}
	
	func testUpdateSequence() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let updateExpectation = XCTestExpectation(description: "update")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { value -> MockEntity in
			let mock = MockEntity()
			mock.testValue = value
			return mock
		}
		
		// When
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		database.update(
			[newEntities[3].id, newEntities[7].id]
		) { (entities: [MockEntity]) in
			entities.forEach {
				$0.testValue = 999
			}
			updateExpectation.fulfill()
		} completion: { _ in }
		
		// Then
		database.read(
			predicate: NSPredicate(format: "testValue == %d", 999)
		) { (result: Result<[MockEntity], Error>) in
			switch result {
			case .success(let storedObjects):
				XCTAssertEqual(storedObjects.count, 2)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
		wait(for: [createExpectation, updateExpectation, readExpectation], timeout: 2)
	}
	
	func testUpdate_notExistedEntity() {
		let updateExpectation = XCTestExpectation(description: "update")
		database.update(UUID().uuidString) { (_: MockEntity) in
			XCTFail()
		} completion: { result in
			if case Result.failure(_) = result {
				XCTAssertTrue(true)
			} else {
				XCTFail()
			}
			updateExpectation.fulfill()
		}
		wait(for: [updateExpectation], timeout: 2)
	}
	
	// MARK: - Delete Tests
	
	func testDelete() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let deleteExpectation = XCTestExpectation(description: "delete")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { _ in
			MockEntity()
		}
		
		// When
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		database.delete(newEntities[4].id) { (result: Result<MockEntity, Error>) in
			if case Result.failure(_) = result {
				XCTFail()
			}
			deleteExpectation.fulfill()
		}
		
		// Then
		database.read(newEntities[4].id) { (result: Result<MockEntity, Error>) in
			switch result {
			case .success:
				XCTFail()
			case .failure(_):
				XCTAssertTrue(true)
			}
			readExpectation.fulfill()
		}
		wait(for: [createExpectation, deleteExpectation, readExpectation], timeout: 2)
	}
	
	func testDeleteSequence() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let deleteExpectation = XCTestExpectation(description: "delete")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { _ in
			MockEntity()
		}
		let deletedIDs = [newEntities[3].id, newEntities[6].id]
		
		// When
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		database.delete(deletedIDs) { (result: Result<[MockEntity], Error>) in
			if case Result.failure(_) = result {
				XCTFail()
			}
			deleteExpectation.fulfill()
		}
		
		// Then
		database.read { (result: Result<[MockEntity], Error>) in
			switch result {
			case .success(let storedObjects):
				XCTAssert(
					!storedObjects.contains {
						$0.id == deletedIDs.first ||
						$0.id == deletedIDs.last
					}
				)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
		wait(for: [createExpectation, deleteExpectation, readExpectation], timeout: 2)
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
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		database.erase { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			deleteExpectation.fulfill()
		}
		
		// Then
		database.read { (result: Result<[MockEntity], Error>) in
			switch result {
			case .success(let storedObjects):
				XCTAssert(storedObjects.isEmpty)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
		wait(for: [createExpectation, deleteExpectation, readExpectation], timeout: 2)
	}
	
}

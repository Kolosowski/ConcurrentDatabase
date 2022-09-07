import XCTest
import RealmSwift
@testable import ConcurrentDatabase

final class DatabaseServiceTestCase: XCTestCase {
	
	private let database: DatabaseService = DatabaseService(
		configuration: Realm.Configuration(
			inMemoryIdentifier: "inMemory"
		)
	)
	
	// MARK: - Life Cycle
	
	override func tearDown() {
		database.deleteAll { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
		}
	}
	
	// MARK: - Tests
	
	func testRead() {
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
		database.read(
			predicate: nil,
			sortDescriptors: []
		) { (result: Result<[MockEntity], Error>) in
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
	
	func testReadWithPredicateAndSort() {
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
			predicate: NSPredicate(format: "testValue == 2 OR testValue == 4"),
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
	
	func testUpdate() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let updateExpectation = XCTestExpectation(description: "update")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntity = MockEntity()
		let newEntityValue = 10
		newEntity.testValue = newEntityValue
		
		// When
		database.create([newEntity]) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		let updatedEntityValue = newEntityValue + 100
		database.update(newEntity.id) { (result: Result<MockEntity, Error>) in
			switch result {
			case .success(let object):
				object.testValue = updatedEntityValue
			case .failure(_):
				XCTFail()
			}
			updateExpectation.fulfill()
		}
		
		// Then
		database.read(
			predicate: nil,
			sortDescriptors: []
		) { (result: Result<[MockEntity], Error>) in
			switch result {
			case .success(let storedObjects):
				let object = storedObjects.first
				XCTAssertEqual(object?.id, newEntity.id)
				XCTAssertEqual(object?.testValue, updatedEntityValue)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
		wait(for: [createExpectation, updateExpectation, readExpectation], timeout: 2)
	}
	
	func testUpdate_notExistedEntity() {
		let updateExpectation = XCTestExpectation(description: "update")
		
		database.update(UUID().uuidString) { (result: Result<MockEntity, Error>) in
			switch result {
			case .success:
				XCTFail()
			case .failure:
				XCTAssertTrue(true)
			}
			updateExpectation.fulfill()
		}
		wait(for: [updateExpectation], timeout: 2)
	}
	
	func testDelete() {
		// Given
		let createExpectation = XCTestExpectation(description: "create")
		let deleteExpectation = XCTestExpectation(description: "delete")
		let readExpectation = XCTestExpectation(description: "read")
		let newEntities = (.zero...10).map { _ in
			MockEntity()
		}
		let newEntitiesIDs = newEntities.map {
			$0.id
		}
		
		// When
		database.create(newEntities) { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			createExpectation.fulfill()
		}
		let deletedEntitiesIDs = newEntities[2...5].map {
			$0.id
		}
		database.delete(deletedEntitiesIDs) { (result: Result<[MockEntity], Error>) in
			if case Result.failure(_) = result {
				XCTFail()
			}
			deleteExpectation.fulfill()
		}
		
		// Then
		database.read(
			predicate: nil,
			sortDescriptors: []
		) { (result: Result<[MockEntity], Error>) in
			switch result {
			case .success(let storedObjects):
				let storedObjectsIDs = storedObjects.map {
					$0.id
				}
				XCTAssertNotEqual(storedObjectsIDs, newEntitiesIDs)
			case .failure(_):
				XCTFail()
			}
			readExpectation.fulfill()
		}
		wait(for: [createExpectation, deleteExpectation, readExpectation], timeout: 2)
	}
	
	func testDeleteAll() {
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
		database.deleteAll { result in
			if case Result.failure(_) = result {
				XCTFail()
			}
			deleteExpectation.fulfill()
		}
		
		// Then
		database.read(
			predicate: nil,
			sortDescriptors: []
		) { (result: Result<[MockEntity], Error>) in
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

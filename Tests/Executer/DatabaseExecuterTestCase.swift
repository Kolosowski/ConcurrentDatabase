import XCTest
import RealmSwift
@testable import ConcurrentDatabase

final class DatabaseExecuterTestCase: XCTestCase {
	
	// MARK: - Stored Properties - Testable
	
	let executer: DatabaseExecuter = .init(
		configuration: Realm.Configuration(
			inMemoryIdentifier: "inMemory"
		)
	)
	
	// MARK: - Life Cycle
	
	override func tearDown() {
		do {
			try executer.erase()
		} catch {
			XCTFail()
		}
	}
	
	// MARK: - Tests
	
	func testSave() {
		do {
			// Given
			let entities = (.zero...15).map { _ in
				MockEntity()
			}
			
			// When
			try executer.save(entities)
			
			// Then
			let fetchedEntities: [MockEntity] = try executer.fetch()
			XCTAssertEqual(entities.count, fetchedEntities.count)
		} catch {
			XCTFail()
		}
	}
	
	func testFetchWithPredicate() {
		do {
			// Given
			let entities = (.zero...15).map {
				let entity = MockEntity()
				entity.testValue = $0
				return entity
			}
			
			// When
			try executer.save(entities)
			
			// Then
			let fetchedEntities: [MockEntity] = try executer.fetch(
				predicate: NSPredicate(format: "testValue == %d", 4)
			)
			XCTAssertEqual(fetchedEntities.count, 1)
			XCTAssertEqual(fetchedEntities.first?.testValue, 4)
		} catch {
			XCTFail()
		}
	}
	
	func testFetchWithSort() {
		do {
			// Given
			let entities = (.zero...15).map {
				let entity = MockEntity()
				entity.testValue = $0
				return entity
			}
			
			// When
			try executer.save(entities)
			
			// Then
			let fetchedEntities: [MockEntity] = try executer.fetch(
				sortDescriptors: [NSSortDescriptor(key: "testValue", ascending: true)]
			)
			XCTAssert(fetchedEntities.last!.testValue > fetchedEntities.first!.testValue)
		} catch {
			XCTFail()
		}
	}
	
	func testModify() {
		do {
			// Given
			let testValue = 123
			let entities = (.zero...15).map {
				let entity = MockEntity()
				entity.testValue = $0
				return entity
			}
			
			// When
			try executer.save(entities)
			try executer.modify([entities[5].id]) { (entities: [MockEntity]) in
				entities.forEach {
					$0.testValue = testValue
				}
			}
			
			// Then
			let fetchedEntities: [MockEntity] = try executer.fetch(
				predicate: NSPredicate(format: "testValue == %d", testValue)
			)
			XCTAssert(!fetchedEntities.isEmpty)
		} catch {
			XCTFail()
		}
	}
	
	func testModifyWithIncorrectPrimaryKey() {
		do {
			let entities = (.zero...15).map {
				let entity = MockEntity()
				entity.testValue = $0
				return entity
			}
			
			try executer.save(entities)
			XCTAssertThrowsError(
				try executer.modify(["Foo"]) { (entities: [MockEntity]) in
					entities.forEach {
						$0.testValue = .zero
					}
				}
			)
		} catch {
			XCTFail()
		}
	}
	
	func testRemove() {
		do {
			// Given
			let entities = (.zero...15).map {
				let entity = MockEntity()
				entity.testValue = $0
				return entity
			}
			
			// When
			try executer.save(entities)
			let _: [MockEntity] = try executer.remove([entities[5].id])
			
			// Then
			let fetchedEntities: [MockEntity] = try executer.fetch()
			XCTAssertNotEqual(entities.count, fetchedEntities.count)
		} catch {
			XCTFail()
		}
	}
	
	func testRemoveWithIncorrectPrimaryKey() {
		do {
			let entities = (.zero...15).map {
				let entity = MockEntity()
				entity.testValue = $0
				return entity
			}
			
			try executer.save(entities)
			let _: [MockEntity] = try executer.remove(["Foo"])
			XCTFail()
		} catch {
			XCTAssert(error is DatabaseError)
		}
	}
	
	func testErase() {
		do {
			// Given
			let entities = (.zero...15).map {
				let entity = MockEntity()
				entity.testValue = $0
				return entity
			}
			
			// When
			try executer.save(entities)
			try executer.erase()
			
			// Then
			let fetchedEntities: [MockEntity] = try executer.fetch()
			XCTAssert(fetchedEntities.isEmpty)
		} catch {
			XCTFail()
		}
	}
	
}

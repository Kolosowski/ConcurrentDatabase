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
			.erase()
			.sink { completion in
				if case Subscribers.Completion.failure(_) = completion {
					XCTFail()
				}
			} receiveValue: { _ in }
			.store(in: &cancellables)
	}
	
}

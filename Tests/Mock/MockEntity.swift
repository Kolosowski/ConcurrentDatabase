import Foundation
import RealmSwift

final class MockEntity: Object {
	
	// MARK: - Stored Properties - Data
	
	@Persisted private(set) var id: String = UUID().uuidString
	@Persisted var testValue: Int
	
	// MARK: - Primary Key
	
	override class func primaryKey() -> String? {
		"id"
	}
	
}

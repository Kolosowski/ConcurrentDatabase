import Foundation

public extension DatabaseService {
	
	enum Error: Swift.Error {
		case objectNotFound
		case objectWithKeyNotFound(primaryKey: String)
		case fetchMultiple(errors: [Swift.Error])
	}
	
}

import Foundation

extension DatabaseService {
	
	enum Error: Swift.Error {
		case objectNotFound(primaryKey: String)
		case fetchMultiple(errors: [Swift.Error])
	}
	
}

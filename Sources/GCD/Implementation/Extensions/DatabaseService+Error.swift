import Foundation

extension DatabaseService {
	
	enum Error: Swift.Error {
		case objectNotFound(primaryKey: String)
	}
	
}

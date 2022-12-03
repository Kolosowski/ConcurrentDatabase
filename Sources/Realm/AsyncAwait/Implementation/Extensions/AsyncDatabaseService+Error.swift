import Foundation

extension AsyncDatabaseService {
	
	enum Error: Swift.Error {
		case objectNotFound(primaryKey: String)
		case objectNotFound(filter: String)
	}
	
}

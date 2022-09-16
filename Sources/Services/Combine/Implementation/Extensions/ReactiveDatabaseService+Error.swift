import Foundation

extension ReactiveDatabaseService {
	
	enum Error: Swift.Error {
		case objectNotFound(primaryKey: String)
		case objectNotFound(filter: String)
		case multipleObjectsNotUpdated
		case multipleObjectsNotRemoved
	}
	
}

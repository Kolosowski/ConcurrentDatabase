import Foundation

enum DatabaseError: Error {
	
	case objectNotFound(primaryKey: String)
	case objectNotFound(filter: String)
	
}

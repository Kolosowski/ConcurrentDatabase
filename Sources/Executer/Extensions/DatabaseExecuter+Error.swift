import Foundation

extension DatabaseExecuter {
	
	enum Error: Swift.Error {
		case objectNotFound(primaryKey: String)
	}
	
}

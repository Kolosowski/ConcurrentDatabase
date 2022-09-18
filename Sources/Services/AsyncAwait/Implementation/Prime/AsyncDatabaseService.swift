import Foundation
import RealmSwift

public final actor AsyncDatabaseService {
	
	let executer: DatabaseExecuter
	
	// MARK: - Life Cycle
	
	init(configuration: Realm.Configuration) {
		executer = .init(configuration: configuration)
	}
	
}

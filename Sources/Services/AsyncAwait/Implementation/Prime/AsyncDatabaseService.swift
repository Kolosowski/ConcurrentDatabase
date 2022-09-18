import Foundation
import RealmSwift

public final actor AsyncDatabaseService {
	
	// MARK: - Stored Properties - Tools
	
	let executer: DatabaseExecuter
	
	// MARK: - Life Cycle
	
	init(configuration: Realm.Configuration) {
		executer = .init(configuration: configuration)
	}
	
}

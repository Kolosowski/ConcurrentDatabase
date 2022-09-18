import Foundation
import RealmSwift

public final actor AsyncDatabaseService {
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.async.workQueue")
	let executer: DatabaseExecuter
	
	// MARK: - Life Cycle
	
	init(configuration: Realm.Configuration) {
		executer = .init(configuration: configuration)
	}
	
}

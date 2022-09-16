import Foundation
import RealmSwift

public struct ReactiveDatabaseService {
	
	// MARK: - Stored Properties - Tools
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.reactive.workQueue")
	let executer: DatabaseExecuter
	
	// MARK: - Life Cycle
	
	init(configuration: Realm.Configuration) {
		executer = .init(configuration: configuration)
	}
	
}

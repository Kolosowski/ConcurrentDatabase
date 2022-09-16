import Foundation
import RealmSwift

public struct DatabaseService {
	
	// MARK: - Stored Properties - Tools
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.workQueue")
	let executer: DatabaseExecuter
	
	// MARK: - Life Cycle
	
	init(configuration: Realm.Configuration) {
		executer = .init(configuration: configuration)
	}
	
}

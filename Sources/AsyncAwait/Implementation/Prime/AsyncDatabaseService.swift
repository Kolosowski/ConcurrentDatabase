import Foundation
import RealmSwift

final actor AsyncDatabaseService {
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.async.workQueue")
	let configuration: Realm.Configuration
	
	// MARK: - Life Cycle
	
	init(configuration: Realm.Configuration) {
		self.configuration = configuration
	}
	
}

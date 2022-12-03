import Foundation
import RealmSwift

public struct DatabaseService {
	
	// MARK: - Stored Properties - Tools
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.workQueue")
	let configuration: Realm.Configuration
	
}

import Foundation
import RealmSwift

public final actor AsyncDatabaseService {
	
	// MARK: - Stored Properties - Tools
	
	let configuration: Realm.Configuration
	
	// MARK: - Life Cycle
	
	init(configuration: Realm.Configuration) {
		self.configuration = configuration
	}
	
}

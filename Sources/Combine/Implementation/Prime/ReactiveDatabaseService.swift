import Foundation
import RealmSwift

public struct ReactiveDatabaseService {
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.reactive.workQueue")
	let configuration: Realm.Configuration
	
}

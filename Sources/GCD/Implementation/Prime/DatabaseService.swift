import Foundation
import RealmSwift

struct DatabaseService {
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.workQueue")
	let configuration: Realm.Configuration
	
}

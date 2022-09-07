import Foundation
import RealmSwift

struct DatabaseService: DatabaseServiceProtocol {
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.workQueue")
	let configuration: Realm.Configuration
	
}

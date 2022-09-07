import Foundation
import RealmSwift

public struct DatabaseService: DatabaseServiceProtocol {
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.workQueue")
	let configuration: Realm.Configuration
	
}

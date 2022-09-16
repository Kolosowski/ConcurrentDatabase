import Foundation
import RealmSwift

public struct DatabaseService {
	
	let workQueue: DispatchQueue = .init(label: "com.databaseService.workQueue")
	let configuration: Realm.Configuration
	
}

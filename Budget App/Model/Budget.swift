import Foundation

struct Budget: Identifiable, Codable {
	let id: UUID
	var type: LogType
	var monthlyLimit: Double
	
	init(id: UUID = UUID(), type: LogType, monthlyLimit: Double) {
		self.id = id
		self.type = type
		self.monthlyLimit = monthlyLimit
	}
}

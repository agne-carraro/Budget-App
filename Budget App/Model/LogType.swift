enum LogType: String, Codable, CaseIterable {
    case gift
    case salary
    case transportation
    case food 
    case entertainment
    case other
}

extension LogType {
	var icon: String {
		switch self {
		case .gift: return "gift.fill"
		case .salary: return "dollarsign.circle.fill"
		case .transportation: return "car.fill"
		case .food: return "fork.knife"
		case .entertainment: return "film.fill"
		case .other: return "questionmark.circle.fill"
		}
	}
}

struct IdentifiableType: Identifiable {
    let type: LogType
    var id: LogType { type }
}

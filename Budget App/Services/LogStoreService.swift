import Foundation

protocol LogStoring {
	func load() -> [Log]
	func save(logs: [Log])
}


class LogStoreService: LogStoring {
    private let saveKey = "logs"

    func load() -> [Log] {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let logs = try? JSONDecoder().decode([Log].self, from: data) else {
            return []
        }
        return logs
    }

    func save(logs: [Log]) {
        if let data = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}

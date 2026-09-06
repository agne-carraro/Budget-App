import Foundation

func exportToCSV(logs: [Log]) -> URL? {

    var rows: [String] = ["date,amount,type,note"]

    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX")

    for log in logs {
        let date: String = formatter.string(from: log.date)
        let amount: String = String(format: "%.2f", log.amount)
        let type = log.type.rawValue
        var note: String = log.note.replacingOccurrences(of: "\"", with: "\"\"")
        note = "\"\(note)\""
        let row: String = date + "," + amount + "," + type + "," + note
        rows.append(row)
    }

    let csvString = rows.joined(separator: "\n")
    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(
        "budget-export-\(UUID().uuidString).csv")
    guard let csvData = csvString.data(using: .utf8) else {
        return nil
    }

    do {
        try csvData.write(to: fileURL)
        return fileURL
    } catch {
        print("Failed to write CSV: \(error)")
        return nil
    }
}

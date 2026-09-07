import Foundation

func exportFullData(logs: [Log], budgets: [Budget], startingBalance: Double) -> URL? {
    exportToCSV(
        sections: [
            startingBalanceSection(startingBalance),
            logsSection(from: logs),
            budgetsSection(from: budgets)
        ],
        title: "All Data"
    )
}

func exportToCSV(sections: [CSVSection], title: String) -> URL? {
    var allLines: [String] = [title, ""]

    for section in sections {
        allLines.append(section.title)
        if let header = section.header {
            allLines.append(header)
        }
        allLines.append(contentsOf: section.rows)
        allLines.append("")
    }

    let csvString = allLines.joined(separator: "\n")

    guard let csvData = csvString.data(using: .utf8) else {
        return nil
    }

    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("budget-export-\(UUID().uuidString).csv")

    do {
        try csvData.write(to: fileURL)
        return fileURL
    } catch {
        print("Failed to write CSV: \(error)")
        return nil
    }
}

func startingBalanceSection(_ balance: Double) -> CSVSection {
    let row = String(format: "%.2f", balance)
    return CSVSection(title: "Starting Balance", header: nil, rows: [row])
}

func logsSection(from logs: [Log]) -> CSVSection {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX")

    let rows = logs.map { log -> String in
        let date = formatter.string(from: log.date)
        let amount = String(format: "%.2f", log.amount)
        let type = log.type.rawValue
        let escapedNote = log.note.replacingOccurrences(of: "\"", with: "\"\"")
        let note = "\"\(escapedNote)\""
        return "\(date),\(amount),\(type),\(note)"
    }

    return CSVSection(title: "Logs", header: "date,amount,type,note", rows: rows)
}

func budgetsSection(from budgets: [Budget]) -> CSVSection {
    let rows = budgets.map { budget -> String in
        let type = budget.type.rawValue
        let limit = String(format: "%.2f", budget.monthlyLimit)
        return "\(type),\(limit)"
    }

    return CSVSection(title: "Budgets", header: "type,monthlyLimit", rows: rows)
}
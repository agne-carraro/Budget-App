import Testing
import Foundation
@testable import Budget_App

struct LogExportServiceTests {

    @Test func exportsBasicLogCorrectly() throws {
        let date = DateComponents(calendar: .current, year: 2026, month: 9, day: 5).date!
        let log = Log(amount: 42.5, date: date, type: .food, note: "Lunch")

        let url = exportToCSV(logs: [log])
        let content = try #require(url.flatMap { try? String(contentsOf: $0, encoding: .utf8) })

        let lines = content.split(separator: "\n")
        #expect(lines.count == 2) // header + 1 row
        #expect(lines[0] == "date,amount,type,note")
        #expect(lines[1] == "05-09-2026,42.50,food,\"Lunch\"")
    }

    @Test func escapesCommaInNote() throws {
        let date = DateComponents(calendar: .current, year: 2026, month: 1, day: 1).date!
        let log = Log(amount: 10, date: date, type: .gift, note: "Coffee, tea, snacks")

        let url = exportToCSV(logs: [log])
        let content = try #require(url.flatMap { try? String(contentsOf: $0, encoding: .utf8) })

        #expect(content.contains("\"Coffee, tea, snacks\""))
    }

    @Test func escapesQuotesInNote() throws {
        let date = DateComponents(calendar: .current, year: 2026, month: 1, day: 1).date!
        let log = Log(amount: 10, date: date, type: .other, note: "Mom said \"pay me back\"")

        let url = exportToCSV(logs: [log])
        let content = try #require(url.flatMap { try? String(contentsOf: $0, encoding: .utf8) })

        #expect(content.contains("\"Mom said \"\"pay me back\"\"\""))
    }

    @Test func emptyLogsProducesHeaderOnly() throws {
        let url = exportToCSV(logs: [])
        let content = try #require(url.flatMap { try? String(contentsOf: $0, encoding: .utf8) })

        let lines = content.split(separator: "\n")
        #expect(lines.count == 1)
        #expect(lines[0] == "date,amount,type,note")
    }
}
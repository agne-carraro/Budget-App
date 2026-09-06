import SwiftUI

struct AddLogView: View {
    @ObservedObject var viewModel: LogListViewModel
    @Environment(\.dismiss) private var dismiss
	
	let logToEdit: Log?

    @State private var amount: Double = 0
    @State private var date: Date = Date()
    @State private var type: LogType = .other
    @State private var note: String = ""
    @State private var isIncome: Bool = false
	
	init(viewModel: LogListViewModel, logToEdit: Log? = nil) {
		self.viewModel = viewModel
		self.logToEdit = logToEdit
		_amount = State(initialValue: logToEdit?.amount ?? 0)
		_date = State(initialValue: logToEdit?.date ?? Date())
		_type = State(initialValue: logToEdit?.type ?? .other)
		_note = State(initialValue: logToEdit?.note ?? "")
		_isIncome = State(initialValue: logToEdit?.isIncome ?? false)
	}

    var body: some View {
        NavigationStack {
            Form {
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.decimalPad)

                DatePicker("Date", selection: $date, displayedComponents: .date)

                Picker("Category", selection: $type) {
                    ForEach([LogType.gift, .salary, .transportation, .food, .entertainment, .other], id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }

                Picker("Type", selection: $isIncome) {
                    Text("Expense").tag(false)
                    Text("Income").tag(true)
                }
                .pickerStyle(.segmented)

                TextField("Note", text: $note)
            }
			.navigationTitle(logToEdit == nil ? "Add Log" : "Edit Log")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
					Button(logToEdit == nil ? "Add" : "Save") {
						if let logToEdit {
							viewModel.updateLog(id: logToEdit.id, amount: amount, date: date, type: type, note: note, isIncome: isIncome)
						} else {
							viewModel.addLog(amount: amount, date: date, type: type, note: note, isIncome: isIncome)
						}
						dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddLogView(viewModel: LogListViewModel(store: LogStoreService()))
}

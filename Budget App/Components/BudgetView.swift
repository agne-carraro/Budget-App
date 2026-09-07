import SwiftUI

struct BudgetView: View {
	let budget: Budget
	let spent: Double
	let effectiveLimit: Double
	let progress: Double

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: budget.type.icon)
				Text(budget.type.rawValue.capitalized)
					.font(.headline)

				Spacer()

				Text("\(max(spent, 0), specifier: "%.2f") / \(effectiveLimit, specifier: "%.2f")")
					.font(.subheadline)
					.foregroundColor(.secondary)
			}

			ProgressView(value: progress)
				.tint(progress >= 1.0 ? .red : .accentColor)
		}
		.padding(.vertical, 4)
	}
}

#Preview {
	BudgetView(budget: Budget(type: .food, monthlyLimit: 300), spent: 400, effectiveLimit: 300, progress: 1.2)
}

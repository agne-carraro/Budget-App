import SwiftUI

struct BudgetView: View {
	let budget: Budget
	let spent: Double
	let effectiveLimit: Double
	let progress: Double
	
	private var progressColor: Color {
		switch progress {
		case ..<0.7:
			return .green
		case 0.7..<0.86:
			return .orange
		default:
			return .red
		}
	}

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
				.tint(progressColor)
		}
		.padding(.vertical, 4)
	}
}

#Preview {
	BudgetView(budget: Budget(type: .food, monthlyLimit: 300, year: 2026, month: 9), spent: 200, effectiveLimit: 300, progress: 0.86)
}

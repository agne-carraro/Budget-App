import SwiftUI

struct MonthSelectorView: View {
	@Binding var selectedMonth: SelectedMonth

	var body: some View {
		HStack {
			Button {
				selectedMonth = selectedMonth.offset(by: -1)
			} label: {
				Image(systemName: "chevron.left")
					.font(.subheadline.weight(.semibold))
			}

			Spacer()

			Text(selectedMonth.displayString)
				.font(.subheadline.weight(.semibold))

			Spacer()

			Button {
				selectedMonth = selectedMonth.offset(by: 1)
			} label: {
				Image(systemName: "chevron.right")
					.font(.subheadline.weight(.semibold))
			}
		}
		.foregroundColor(.primary)
		.padding(.vertical, 10)
		.padding(.horizontal, 20)
		.background(
			Capsule()
				.fill(Color(.secondarySystemGroupedBackground))
				.shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
		)
		.padding(.horizontal, 60)
	}
}

#Preview {
	ZStack {
		Color(.systemGroupedBackground).ignoresSafeArea()
		MonthSelectorView(selectedMonth: .constant(.current))
	}
}

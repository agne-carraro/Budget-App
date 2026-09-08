import SwiftUI

struct OverallBudgetView: View {
    let spent: Double
    let limit: Double
    let progress: Double

    private var progressColor: Color {
        switch progress {
        case ..<0.7: return .green
        case 0.7..<0.9: return .orange
        default: return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Overall")
                    .font(.headline)
                Spacer()
                Text("\(max(spent, 0), specifier: "%.2f") / \(limit, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            ProgressView(value: progress)
                .tint(progressColor)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}
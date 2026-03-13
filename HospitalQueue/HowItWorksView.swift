import SwiftUI

struct HowItWorksView: View {
    @Environment(\.dismiss) private var dismiss

    private let steps: [(icon: String, title: String, detail: String)] = [
        ("1.circle.fill", "Select your service", "Choose from Emergency, Admission, Pharmacy, or OCD/Consultant based on your need."),
        ("2.circle.fill", "Get your token", "Receive a unique queue token. For consultant visits, pick your doctor, time, and venue first."),
        ("3.circle.fill", "Track your turn", "See how many people are ahead and your estimated wait time on the Queue Status screen."),
        ("4.circle.fill", "Show at the counter", "When your number is called, show your token or QR code at the assigned counter.")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Quick Booking lets you join the queue from your phone and skip the line. Here’s how it works:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)

                    ForEach(Array(steps.enumerated()), id: \.offset) { _, step in
                        HStack(alignment: .top, spacing: 16) {
                            Image(systemName: step.icon)
                                .font(.title2)
                                .foregroundColor(Color(.systemTeal))
                                .frame(width: 32, alignment: .center)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(step.title)
                                    .font(.headline)
                                Text(step.detail)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }

                    Spacer(minLength: 24)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("How it works")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct HowItWorksView_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorksView()
    }
}

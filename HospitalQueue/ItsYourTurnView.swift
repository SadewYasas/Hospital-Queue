import SwiftUI

struct ItsYourTurnView: View {
    @Binding var path: [Route]
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemTeal).opacity(0.06), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 72))
                    .foregroundColor(.green)

                Text("It's your turn!")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Please proceed to \(auth.counters.first ?? "your assigned counter")")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 8) {
                    Text("Token")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(auth.currentToken)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemTeal).opacity(0.12))
                .cornerRadius(12)
                .padding(.horizontal, 32)

                Spacer()

                Button(action: {
                    path.append(.visitComplete)
                }) {
                    Text("I'm done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.animated)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct VisitCompleteView: View {
    @Binding var path: [Route]
    @EnvironmentObject var auth: AuthViewModel

    @State private var showNextPopup = false
    @State private var nextService: String?
    @State private var showLaterPicker = false
    @State private var laterDate: Date = Date().addingTimeInterval(30 * 60)

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemTeal).opacity(0.06), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(Color(.systemTeal))

                Text("Thanks for your visit!")
                    .font(.title2)
                    .fontWeight(.bold)

                Button(action: { /* Leave a review — would open App Store */ }) {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("Leave a review")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.animated)
                .padding(.horizontal, 24)

                Button(action: {
                    auth.clearActiveQueue()
                    path.removeAll()
                }) {
                    Text("Back to dashboard")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.animated)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            let completed = auth.selectedService
            let next = auth.nextService(after: completed)
            if let next {
                nextService = next
                showNextPopup = true
            }
        }
        .confirmationDialog(
            nextService.map { "Your next appointment is \($0)." } ?? "Next appointment",
            isPresented: $showNextPopup,
            titleVisibility: .visible
        ) {
            Button("Go now") {
                guard let next = nextService else { return }
                auth.clearActiveQueue()
                auth.generateToken(for: next, immediateTurn: false)
                path.removeAll()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    path.append(.queueStatus(isNewlyCreated: true))
                }
            }
            Button("Later") {
                showLaterPicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showLaterPicker) {
            LaterTokenSheet(
                nextService: nextService ?? "",
                laterDate: $laterDate,
                onConfirm: { date in
                    guard let next = nextService else { return }
                    auth.scheduleNextToken(for: next, at: date)
                    auth.clearActiveQueue()
                    path.removeAll()
                }
            )
            .presentationDetents([.medium])
        }
    }
}

private struct LaterTokenSheet: View {
    @Environment(\.dismiss) private var dismiss
    let nextService: String
    @Binding var laterDate: Date
    let onConfirm: (Date) -> Void

    private var minDate: Date { Date().addingTimeInterval(5 * 60) }
    private var maxDate: Date { Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date().addingTimeInterval(7 * 24 * 60 * 60) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Schedule for later")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("We’ll generate a token for **\(nextService)** at the time you choose.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                DatePicker(
                    "Time",
                    selection: $laterDate,
                    in: minDate...maxDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)

                Spacer()
            }
            .padding(20)
            .navigationTitle("Later")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Schedule") {
                        onConfirm(laterDate)
                        dismiss()
                    }
                    .disabled(nextService.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

import SwiftUI

struct QuickBookingView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var path: [Route]

    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date?

    private let venue = "Main Hospital"
    private let serviceName = "Quick Booking"

    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.date(byAdding: .day, value: 7, to: start) ?? start
        return start...end
    }

    private var timeSlots: [Date] {
        let calendar = Calendar.current
        let base = calendar.startOfDay(for: selectedDate)
        let hours = [9, 10, 11, 13, 14, 15, 16]
        let minutes = [0, 30]

        var slots: [Date] = []
        for h in hours {
            for m in minutes {
                if let d = calendar.date(bySettingHour: h, minute: m, second: 0, of: base) {
                    slots.append(d)
                }
            }
        }

        let now = Date()
        if calendar.isDate(selectedDate, inSameDayAs: now) {
            slots = slots.filter { $0 >= now.addingTimeInterval(10 * 60) }
        }

        return slots
    }

    private var dateLabel: String {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .none
        return f.string(from: selectedDate)
    }

    private func timeLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        return f.string(from: date)
    }

    private func appointmentTimeLabel(date: Date, time: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        let calendar = Calendar.current
        let merged = calendar.date(
            bySettingHour: calendar.component(.hour, from: time),
            minute: calendar.component(.minute, from: time),
            second: 0,
            of: date
        ) ?? time
        return f.string(from: merged)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemBlue).opacity(0.10), Color.white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Quick Booking")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Pick a date and choose an available time slot.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Date")
                                .font(.headline)
                            DatePicker(
                                "Date",
                                selection: $selectedDate,
                                in: dateRange,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .onChange(of: selectedDate) { _ in
                                selectedTime = nil
                            }

                            Text(dateLabel)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Available slots")
                                .font(.headline)

                            if timeSlots.isEmpty {
                                HStack(spacing: 10) {
                                    Image(systemName: "clock.badge.exclamationmark")
                                        .foregroundColor(.secondary)
                                    Text("No remaining slots for this date. Pick another day.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 8)
                            } else {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                    ForEach(timeSlots, id: \.self) { slot in
                                        Button(action: {
                                            withAnimation(Animation.iosSnappy) {
                                                selectedTime = slot
                                            }
                                        }) {
                                            Text(timeLabel(slot))
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(selectedTime == slot ? Color(.systemTeal) : Color(.systemGray6))
                                                )
                                                .foregroundColor(selectedTime == slot ? .white : .primary)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)

                        Spacer(minLength: 24)
                    }
                    .padding()
                }

                VStack {
                    Spacer()
                    Button(action: confirmBooking) {
                        Text("Confirm & Generate Token")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.animated)
                    .disabled(selectedTime == nil)
                    .opacity(selectedTime == nil ? 0.6 : 1.0)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: -4)
                }
                .ignoresSafeArea(.keyboard)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func confirmBooking() {
        guard let time = selectedTime else { return }
        let apptTime = appointmentTimeLabel(date: selectedDate, time: time)
        auth.addAppointment(doctor: serviceName, time: apptTime, venue: venue, category: serviceName)
        auth.generateToken(for: serviceName, immediateTurn: false)

        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            path.append(.queueStatus(isNewlyCreated: true))
        }
    }
}

struct QuickBookingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            QuickBookingView(path: .constant([]))
                .environmentObject(AuthViewModel())
        }
    }
}


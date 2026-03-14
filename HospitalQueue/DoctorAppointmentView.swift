import SwiftUI

struct DoctorAppointmentView: View {
    /// This doctor has no wait time — booking them goes straight to "It's your turn".
    static let noWaitDoctorName = "Dr. Fatima Ali"

    @Binding var path: [Route]
    let category: String
    @EnvironmentObject var auth: AuthViewModel

    @State private var selectedDoctor: String?
    @State private var selectedTime: String?
    @State private var selectedVenue: String?

    let doctors = [
        ("Dr. Sarah Khan", "👩‍⚕️", "BDS, MS Dentistry"),
        ("Dr. Ahmed Hassan", "👨‍⚕️", "MBBS, MD Medicine"),
        ("Dr. Fatima Ali", "👩‍⚕️", "MBBS, Pediatrician"),
        ("Dr. Manoj Samaranayaka", "👨‍⚕️", "MBBS"),
        ("Dr. Chanuthya Perera", "👩‍⚕️", "MBBS")
    ]

    let timeSlots = ["9:00 AM", "10:30 AM", "1:00 PM", "2:30 PM", "4:00 PM"]
    let venues = ["Main Hospital", "Clinic A", "Clinic B"]

    var isComplete: Bool {
        selectedDoctor != nil && selectedTime != nil && selectedVenue != nil
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemTeal).opacity(0.06), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Book Appointment")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(category)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: { path.removeAll() }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Doctor Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Doctor")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(doctors, id: \.0) { doc in
                            DoctorCard(
                                name: doc.0,
                                emoji: doc.1,
                                qualification: doc.2,
                                isSelected: selectedDoctor == doc.0,
                                action: {
                                    withAnimation(Animation.iosSnappy) {
                                        selectedDoctor = doc.0
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)

                    // Time Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Time")
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(timeSlots, id: \.self) { time in
                                TimeSlotButton(
                                    time: time,
                                    isSelected: selectedTime == time,
                                    action: {
                                        withAnimation(Animation.iosSnappy) {
                                            selectedTime = time
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Venue Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Venue")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(venues, id: \.self) { venue in
                            VenueButton(
                                venue: venue,
                                isSelected: selectedVenue == venue,
                                action: {
                                    withAnimation(Animation.iosSnappy) {
                                        selectedVenue = venue
                                    }
                                }
                            )
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.bottom, 100)
            }

            // Floating Continue Button
            VStack {
                Spacer()
                if isComplete {
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        if let doctor = selectedDoctor, let time = selectedTime, let venue = selectedVenue {
                            auth.addAppointment(doctor: doctor, time: time, venue: venue, category: category)
                        }
                        let isNoWait = selectedDoctor == Self.noWaitDoctorName
                        auth.generateToken(for: category, immediateTurn: isNoWait)
                        if isNoWait {
                            path.append(.itsYourTurn)
                        } else {
                            path.append(.queueStatus(isNewlyCreated: true))
                        }
                    }) {
                        Text("Confirm & Generate Token")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.animated)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: -4)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
                    .animation(Animation.iosStandard, value: isComplete)
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarBackButtonHidden(false)
    }
}

struct DoctorCard: View {
    let name: String
    let emoji: String
    let qualification: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(emoji)
                    .font(.system(size: 32))

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(qualification)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? Color(.systemTeal) : Color.gray.opacity(0.3))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color(.systemTeal).opacity(0.1) : Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(isSelected ? Color(.systemTeal) : Color.gray.opacity(0.15), lineWidth: 1))
            )
            .animation(Animation.iosSnappy, value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TimeSlotButton: View {
    let time: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(time)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isSelected ? Color(.systemTeal) : Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(isSelected ? Color(.systemTeal) : Color.gray.opacity(0.2), lineWidth: 1))
                )
                .foregroundColor(isSelected ? .white : .primary)
                .animation(Animation.iosSnappy, value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct VenueButton: View {
    let venue: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title2)
                    .foregroundColor(isSelected ? Color(.systemTeal) : Color.gray)

                VStack(alignment: .leading, spacing: 2) {
                    Text(venue)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("5 km away")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? Color(.systemTeal) : Color.gray.opacity(0.3))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color(.systemTeal).opacity(0.1) : Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(isSelected ? Color(.systemTeal) : Color.gray.opacity(0.15), lineWidth: 1))
            )
            .animation(Animation.iosSnappy, value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DoctorAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DoctorAppointmentView(path: .constant([]), category: "OCD/Consultant")
                .environmentObject(AuthViewModel())
        }
    }
}

import SwiftUI

/// Value-based route for navigation; avoids destination re-evaluation when parent re-renders (e.g. after auth updates).
enum Route: Hashable {
    case categorySelection
    case doctorAppointment(String)
    case queueStatus(isNewlyCreated: Bool)
    case itsYourTurn
    case visitComplete
}

struct HomeView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var path: [Route] = []
    @State private var showHowItWorks = false
    @State private var showQuickBooking = false
    @State private var showProfile = false
    @State private var showAppointments = false
    @State private var showAddress = false
    @State private var showReplaceTokenAlert = false

    var body: some View {
        NavigationStack(path: $path) {
            homeContent
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .categorySelection:
                        CategorySelectionView(path: $path)
                            .environmentObject(auth)
                    case .doctorAppointment(let category):
                        DoctorAppointmentView(path: $path, category: category)
                            .environmentObject(auth)
                    case .queueStatus(let isNewlyCreated):
                        QueueStatusView(path: $path, isNewlyCreated: isNewlyCreated)
                            .environmentObject(auth)
                    case .itsYourTurn:
                        ItsYourTurnView(path: $path)
                            .environmentObject(auth)
                    case .visitComplete:
                        VisitCompleteView(path: $path)
                            .environmentObject(auth)
                    }
                }
        }
        .onAppear {
            if auth.consumeScheduledTokenIfDue() != nil {
                path.append(.queueStatus(isNewlyCreated: true))
            }
        }
    }

    private var homeContent: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemTeal).opacity(0.06), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome, \(auth.userName)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Hospital Queue Management")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: { showProfile = true }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal)

                // Promo Banner
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue).opacity(0.15), Color(.systemTeal).opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))

                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(.systemBlue).opacity(0.2), lineWidth: 1)

                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quick Booking")
                                .font(.headline)
                            Text("Skip the line with priority slots")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Button(action: {
                                showQuickBooking = true
                            }) {
                                Text("Book now")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(6)
                            }
                            .buttonStyle(.animated)
                        }
                        Spacer()
                        Image(systemName: "clock.badge.checkmark")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                .padding(.horizontal)

                // Main CTA Button (if already have a token, show queue status; otherwise start creation)
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    if auth.currentToken.isEmpty {
                        path = [.categorySelection]
                    } else {
                        path.append(.queueStatus(isNewlyCreated: false))
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: auth.currentToken.isEmpty ? "plus.circle.fill" : "ticket.fill")
                            .font(.system(size: 24))
                        Text(auth.currentToken.isEmpty ? "Get Service Token" : "View My Token")
                            .font(.headline)
                        Text(auth.currentToken.isEmpty ? "Select your service type" : "Check queue status")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: Color(.systemBlue).opacity(0.25), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(.animated)
                .padding(.horizontal)

                if !auth.currentToken.isEmpty {
                    Button(action: {
                        showReplaceTokenAlert = true
                    }) {
                        Text("Get a new token")
                            .font(.subheadline)
                            .foregroundColor(Color(.systemTeal))
                    }
                    .padding(.top, -8)
                    .alert("Replace current token?", isPresented: $showReplaceTokenAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Replace", role: .destructive) {
                            path = [.categorySelection]
                        }
                    } message: {
                        Text("Your current token (\(auth.currentToken)) will be overwritten. You can only have one active token at a time.")
                    }
                }

                // Quick Stats
                HStack(spacing: 12) {
                    QuickStatCard(title: "Avg Wait", value: "12 min", icon: "hourglass.bottomhalf.filled", color: Color(.systemOrange))
                    QuickStatCard(title: "People Ahead", value: "\(auth.peopleAhead)", icon: "person.2.fill", color: Color(.systemPurple))
                    QuickStatCard(title: "Active Counters", value: "5", icon: "building.2.fill", color: Color(.systemGreen))
                }
                .padding(.horizontal)

                Spacer()

                // Current Token
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Token")
                        .font(.headline)
                        .padding(.horizontal)

                    if !auth.currentToken.isEmpty {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color(.systemTeal).opacity(0.1))
                                .frame(width: 36, height: 36)
                                .overlay(Image(systemName: "checkmark").foregroundColor(.green))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(auth.currentToken)
                                    .font(.headline)
                            }

                            Spacer()

                            Button(action: {
                                path.append(.queueStatus(isNewlyCreated: false))
                            }) {
                                Text("View")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 10)
                                    .background(Color(.systemTeal))
                                    .cornerRadius(6)
                            }
                            .buttonStyle(.animated)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)
                    } else {
                        Text("No active token")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(.vertical)
            .sheet(isPresented: $showHowItWorks) {
                HowItWorksView()
            }
            .sheet(isPresented: $showQuickBooking) {
                QuickBookingView(path: $path)
                    .environmentObject(auth)
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
                    .environmentObject(auth)
            }
            .sheet(isPresented: $showAppointments) {
                AppointmentsSheetView()
                    .environmentObject(auth)
            }
            .sheet(isPresented: $showAddress) {
                AddressSheetView()
                    .environmentObject(auth)
            }
        }
    }
}

// MARK: - Placeholder sheets for user menu items
struct PlaceholderSheetView: View {
    let title: String
    let icon: String
    let message: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundColor(Color(.systemTeal))
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.top, 32)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct AppointmentsSheetView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }

    var body: some View {
        NavigationStack {
            Group {
                if auth.appointments.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 48))
                            .foregroundColor(Color(.systemTeal))
                        Text("No appointments yet")
                            .font(.headline)
                        Text("Book an OCD/Consultant visit to see appointments here.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(auth.appointments) { apt in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(apt.doctor)
                                .font(.headline)
                            Text(apt.category)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 8) {
                                Label(apt.time, systemImage: "clock")
                                Label(apt.venue, systemImage: "mappin.circle")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Appointments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct AddressSheetView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var addressText: String = ""

    var body: some View {
        NavigationStack {
            TextEditor(text: $addressText)
                .padding()
                .font(.body)
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))
                .onAppear { addressText = auth.userAddress }
            .navigationTitle("Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        auth.updateAddress(addressText)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.08))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.2), lineWidth: 1))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView().environmentObject(AuthViewModel())
        }
    }
}

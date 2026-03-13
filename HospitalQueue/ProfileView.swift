import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showAppointments = false
    @State private var showAddress = false
    @State private var showAboutUs = false

    private var appVersionLabel: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
        return "Version \(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(Color(.systemTeal))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(auth.userName.isEmpty ? "Guest" : auth.userName)
                                .font(.headline)
                            if !auth.userEmail.isEmpty {
                                Text(auth.userEmail)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()
                    }
                    .padding(.vertical, 6)
                }

                Section("Account") {
                    Button {
                        showAppointments = true
                    } label: {
                        Label("My Appointments", systemImage: "calendar")
                    }

                    Button {
                        showAddress = true
                    } label: {
                        Label("Address", systemImage: "mappin.circle")
                    }
                }

                Section("About") {
                    Button {
                        showAboutUs = true
                    } label: {
                        Label("About Us", systemImage: "info.circle")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        auth.signOut()
                        dismiss()
                    } label: {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }

                Section {
                    Text(appVersionLabel)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showAppointments) {
                AppointmentsSheetView()
                    .environmentObject(auth)
            }
            .sheet(isPresented: $showAddress) {
                AddressSheetView()
                    .environmentObject(auth)
            }
            .sheet(isPresented: $showAboutUs) {
                AboutUsView()
            }
        }
    }
}

private struct AboutUsView: View {
    var body: some View {
        NavigationStack {
            HowItWorksView()
                .navigationTitle("About Us")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}


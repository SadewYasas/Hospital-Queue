//
//  ProfileView.swift
//  HospitalQueue
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showProfileSection = false
    @State private var showAppointments = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 70))
                        .foregroundColor(Theme.primaryGreen)
                    Text(appState.userName)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            
            Section {
                NavigationLink(destination: ProfileSectionView()) {
                    Label("Profiles", systemImage: "person.2")
                }
                NavigationLink(destination: DoctorListView()) {
                    Label("Appointments", systemImage: "calendar.badge.checkmark")
                }
                Button(action: {}) {
                    Label("Address", systemImage: "mappin")
                }
                Button(action: {}) {
                    Label("About", systemImage: "info.circle")
                }
                Button(action: {}) {
                    Label("Help", systemImage: "questionmark.circle")
                }
                Button(role: .destructive, action: {
                    showLogoutAlert = true
                }) {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Logout", role: .destructive) {
                appState.logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

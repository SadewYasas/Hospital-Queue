//
//  HomeView.swift
//  HospitalQueue
//

import SwiftUI

enum WalkInService: String, CaseIterable {
    case emergency = "Emergency"
    case odc = "ODC/Consultant"
    case admission = "Admission"
    case pharmacy = "Pharmacy"
    
    var icon: String {
        switch self {
        case .emergency: return "cross.case.fill"
        case .odc: return "person.2.fill"
        case .admission: return "doc.text.fill"
        case .pharmacy: return "pills.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .emergency: return .red
        case .odc: return .blue
        case .admission: return .green
        case .pharmacy: return .orange
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var tokenState = TokenState.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                bannerCard
                walkInSection
                serviceButtons
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(Theme.primaryGreen)
                }
            }
        }
        .navigationDestination(isPresented: $tokenState.showTokenGenerated) {
            TokenGeneratedView(serviceType: tokenState.selectedService ?? .emergency)
        }
    }
    
    private var bannerCard: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Theme.tokenGradientStart, Theme.tokenGradientEnd],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
            
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Now avail 30% off on your first booking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    NavigationLink(destination: DoctorListView()) {
                        Text("Pre Book a slot")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.tokenGradientStart)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.leading, 20)
                .padding(.vertical, 20)
                Spacer()
                Image(systemName: "person in badge.dashed.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.trailing, 20)
            }
        }
    }
    
    private var walkInSection: some View {
        HStack {
            Rectangle()
                .fill(Theme.borderGray)
                .frame(height: 1)
            Text("Or walk in now")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            Rectangle()
                .fill(Theme.borderGray)
                .frame(height: 1)
        }
        .padding(.vertical, 8)
    }
    
    private var serviceButtons: some View {
        VStack(spacing: 12) {
            ForEach(WalkInService.allCases, id: \.self) { service in
                Button(action: {
                    tokenState.selectedService = service
                    tokenState.generateToken()
                    tokenState.showTokenGenerated = true
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: service.icon)
                            .font(.title2)
                            .foregroundColor(service.iconColor)
                            .frame(width: 44, height: 44)
                            .background(service.iconColor.opacity(0.15))
                            .cornerRadius(10)
                        Text(service.rawValue)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

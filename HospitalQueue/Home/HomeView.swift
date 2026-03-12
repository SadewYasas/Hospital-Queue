//
//  HomeView.swift
//  HospitalQueue
//

import SwiftUI

// MARK: - Theme Colors
struct AppTheme {
    
    // Primary brand color (Medical teal)
    static let primaryBlue = Color(red: 0/255, green: 150/255, blue: 136/255)
    
    // Light version
    static let primaryBlueLight = Color(red: 128/255, green: 203/255, blue: 196/255)
    
    // Status colors
    static let successGreen = Color(red: 76/255, green: 175/255, blue: 80/255)
    static let warningRed = Color(red: 239/255, green: 83/255, blue: 80/255)
    
    // UI colors
    static let borderGray = Color(UIColor.systemGray5)
    static let textSecondary = Color(UIColor.secondaryLabel)
    
    // Token gradient
    static let tokenGradientStart = primaryBlueLight
    static let tokenGradientEnd = primaryBlue
}

// MARK: - Walk-in Services Enum
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
        case .emergency: return AppTheme.warningRed
        case .odc: return AppTheme.primaryBlue
        case .admission: return AppTheme.primaryBlueLight
        case .pharmacy: return AppTheme.successGreen
        }
    }
}

// MARK: - HomeView
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
        .scrollIndicators(.hidden)
        .background(
            LinearGradient(
                colors: [Color(UIColor.systemGroupedBackground), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .toolbar {
            
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: "heart.text.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(AppTheme.primaryBlue)
                    
                    Text("Home")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.primaryBlue)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppTheme.primaryBlue)
                }
            }
        }
        .navigationDestination(isPresented: $tokenState.showTokenGenerated) {
            TokenGeneratedView(serviceType: tokenState.selectedService ?? .emergency)
        }
    }
    
    // MARK: - Banner Card
    private var bannerCard: some View {
        
        ZStack(alignment: .trailing) {
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.tokenGradientStart.opacity(0.95),
                            AppTheme.tokenGradientEnd.opacity(0.95)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
                .frame(height: 140)
            
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
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                AppTheme.tokenGradientStart,
                                                AppTheme.tokenGradientEnd
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.leading, 20)
                .padding(.vertical, 20)
                
                Spacer()
                
                Image(systemName: "person.in.badge.dashed.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.trailing, 20)
            }
        }
    }
    
    // MARK: - Walk-In Section
    private var walkInSection: some View {
        
        HStack(spacing: 12) {
            
            Rectangle()
                .fill(AppTheme.borderGray.opacity(0.5))
                .frame(height: 1)
            
            Label("Or walk in now", systemImage: "figure.walk")
                .labelStyle(.titleAndIcon)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppTheme.textSecondary)
            
            Rectangle()
                .fill(AppTheme.borderGray.opacity(0.5))
                .frame(height: 1)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Service Buttons
    private var serviceButtons: some View {
        
        VStack(spacing: 12) {
            
            ForEach(WalkInService.allCases, id: \.self) { service in
                
                Button {
                    
                    tokenState.selectedService = service
                    tokenState.generateToken()
                    tokenState.showTokenGenerated = true
                    
                } label: {
                    
                    HStack(spacing: 16) {
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 12)
                                .fill(service.iconColor.opacity(0.12))
                            
                            Image(systemName: service.icon)
                                .font(.title2.weight(.semibold))
                                .foregroundColor(service.iconColor)
                        }
                        .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            
                            Text(service.rawValue)
                                .font(.headline.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            Text("Walk-in service")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundColor(AppTheme.textSecondary.opacity(0.8))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black.opacity(0.04), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

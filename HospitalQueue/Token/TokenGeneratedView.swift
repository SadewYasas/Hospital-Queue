//
//  TokenGeneratedView.swift
//  HospitalQueue
//

import SwiftUI

struct TokenGeneratedView: View {
    let serviceType: WalkInService
    @StateObject private var tokenState = TokenState.shared
    @State private var showQR = false
    @State private var showQueueStatus = false
    @State private var showNavigator = false
    @State private var showEndSession = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                // ✅ Header with success icon
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Theme.primaryGreen)
                        .symbolRenderingMode(.hierarchical)
                        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
                    
                    Text("Your Token Has Been Generated")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                    
                    Text("Scan the QR or proceed with the services below")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                // ✅ Token Card
                tokenCard

                // ✅ Service label
                Text(serviceType.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Theme.textSecondary)

                // ✅ QR & Navigator Buttons
                HStack(spacing: 16) {
                    Button(action: { showQR = true }) {
                        HStack {
                            Image(systemName: "qrcode")
                            Text("Show QR")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.primaryGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Theme.primaryGreen.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Theme.primaryGreen.opacity(0.4), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: NavigatorView()) {
                        HStack {
                            Image(systemName: "location.fill")
                            Text("Navigator")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Theme.primaryGreen)
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 8)
                    }
                    .buttonStyle(.plain)
                }

                // ✅ Primary Action
                PrimaryButton(title: "View Queue Status") {
                    showQueueStatus = true
                }
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)
        }
        .background(
            LinearGradient(
                colors: [Color(UIColor.systemGroupedBackground), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Theme.primaryGreen)
                    Text("Token")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Theme.primaryGreen)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button("End Session") {
                        showEndSession = true
                    }
                    .font(.subheadline)
                    .foregroundStyle(Theme.endSessionRed)
                    .buttonStyle(.plain)

                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(Theme.primaryGreen)
                    }
                }
            }
        }
        .sheet(isPresented: $showEndSession) {
            NavigationStack { EndSessionView() }
        }
        .navigationDestination(isPresented: $showQR) {
            TokenQRView(serviceType: serviceType)
        }
        .navigationDestination(isPresented: $showQueueStatus) {
            QueueStatusView()
        }
    }

    // MARK: - Token Card
    private var tokenCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "ticket.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
                Text("Token Number")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }

            Text(tokenState.currentToken)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            Theme.tokenCardGradient
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 24, x: 0, y: 12)
    }
}

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
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(Theme.primaryGreen)
                    .padding(.top, 24)
                
                Text("Your Token has been generated")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                tokenCard
                
                Text(serviceType.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    Button(action: { showQR = true }) {
                        HStack {
                            Image(systemName: "qrcode")
                            Text("Show QR")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.primaryGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Theme.primaryGreen, lineWidth: 2)
                        )
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    
                    NavigationLink(destination: NavigatorView()) {
                        HStack {
                            Image(systemName: "location.fill")
                            Text("Navigator")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.primaryGreen)
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                
                PrimaryButton(title: "View Queue Status") {
                    showQueueStatus = true
                }
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button("End Session") {
                        showEndSession = true
                    }
                    .font(.subheadline)
                    .foregroundColor(Theme.endSessionRed)
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(Theme.primaryGreen)
                    }
                }
            }
        }
        .sheet(isPresented: $showEndSession) {
            NavigationStack {
                EndSessionView()
            }
        }
        .navigationDestination(isPresented: $showQR) {
            TokenQRView(serviceType: serviceType)
        }
        .navigationDestination(isPresented: $showQueueStatus) {
            QueueStatusView()
        }
    }
    
    private var tokenCard: some View {
        VStack(spacing: 4) {
            Text("Token Number")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            Text(tokenState.currentToken)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Theme.tokenCardGradient)
        .cornerRadius(16)
    }
}

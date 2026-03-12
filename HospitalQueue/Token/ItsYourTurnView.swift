
//
//  ItsYourTurnView.swift
//  HospitalQueue
//

import SwiftUI

struct ItsYourTurnView: View {
    
    @StateObject private var tokenState = TokenState.shared
    @State private var showReview = false
    
    var body: some View {
        
        VStack(spacing: 32) {
            
            header
            
            counterCard
            
            serviceBadge
            
            actionButton
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 30)
        .background(
            LinearGradient(
                colors: [
                    Color(UIColor.systemGroupedBackground),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppTheme.primaryBlue)
                }
            }
        }
        .navigationDestination(isPresented: $showReview) {
            ReviewView()
        }
    }
}

extension ItsYourTurnView {
    
    private var header: some View {
        
        VStack(spacing: 14) {
            
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 80))
                .foregroundStyle(AppTheme.primaryBlue)
                .symbolRenderingMode(.hierarchical)
            
            Text("It's Your Turn")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text("Please proceed to your assigned counter")
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
        }
    }
    
    private var counterCard: some View {
        
        VStack(spacing: 10) {
            
            Text("Counter Number")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            
            Text(String(format: "%02d", tokenState.myCounterNumber))
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Token: \(tokenState.currentToken)")   // CHANGED text
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(   // CHANGED gradient
                        colors: [AppTheme.primaryBlueLight, AppTheme.primaryBlue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.15), radius: 18, y: 10)
        )
    }
    
    private var serviceBadge: some View {
        
        HStack(spacing: 8) {
            
            Image(systemName: tokenState.selectedService.icon)
            
            Text(tokenState.selectedService.rawValue)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
        .foregroundColor(.primary)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.gray.opacity(0.12))
        )
    }
    
    private var actionButton: some View {
        
        PrimaryButton(title: "Proceed to Counter") {
            showReview = true
        }
        .padding(.top, 12)
    }
}


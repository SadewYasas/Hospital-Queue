//
//  ItsYourTurnView.swift
//  HospitalQueue
//

import SwiftUI

struct ItsYourTurnView: View {
    @StateObject private var tokenState = TokenState.shared
    @State private var showReview = false
    
    var body: some View {
        VStack(spacing: 28) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Theme.primaryGreen)
                .padding(.top, 48)
            
            Text("Its Your Turn")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Please proceed to the counter")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            VStack(spacing: 4) {
                Text("Counter Number")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                Text(String(format: "%02d", tokenState.myCounterNumber))
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .background(Theme.tokenCardGradient)
            .cornerRadius(16)
            .padding(.horizontal, 24)
            
            Text("Emergency")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            PrimaryButton(title: "Go Now") {
                showReview = true
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(Theme.primaryGreen)
                }
            }
        }
        .navigationDestination(isPresented: $showReview) {
            ReviewView()
        }
    }
}

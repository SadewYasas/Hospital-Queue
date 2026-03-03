//
//  PasswordResetSuccessView.swift
//  HospitalQueue
//

import SwiftUI

struct PasswordResetSuccessView: View {
    @EnvironmentObject var appState: AppState
    @State private var goToSignIn = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Success!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 48)
            
            Text("Your password has been successfully reset!")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.yellow)
                .padding(.top, 16)
            
            PrimaryButton(title: "Continue to Log In") {
                goToSignIn = true
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToSignIn) {
            SignInView()
        }
    }
}

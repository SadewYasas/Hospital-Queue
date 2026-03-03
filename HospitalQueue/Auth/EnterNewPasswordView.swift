//
//  EnterNewPasswordView.swift
//  HospitalQueue
//

import SwiftUI

struct EnterNewPasswordView: View {
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showSuccess = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Enter New Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 32)
            
            Text("You have been verified! Set the new password.")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            StyledTextField(label: "New Password", placeholder: "********", text: $newPassword, isSecure: true)
            StyledTextField(label: "Confirm Password", placeholder: "********", text: $confirmPassword, isSecure: true)
            
            PrimaryButton(title: "Confirm Change") {
                showSuccess = true
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showSuccess) {
            PasswordResetSuccessView()
        }
    }
}

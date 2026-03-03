//
//  ForgotPasswordView.swift
//  HospitalQueue
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showOTP = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Forgot Password?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 32)
            
            Text("Enter your email address. We will send recovery information.")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            StyledTextField(label: "Email", placeholder: "example@gmail.com", text: $email)
            
            PrimaryButton(title: "Send") {
                showOTP = true
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showOTP) {
            OTPVerificationView(email: email, flow: .forgotPassword)
        }
    }
}

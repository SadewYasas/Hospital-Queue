//
//  OTPVerificationView.swift
//  HospitalQueue
//

import SwiftUI

enum OTPFlow {
    case forgotPassword
    case signUp
}

struct OTPVerificationView: View {
    let email: String
    let flow: OTPFlow
    @State private var digits: [String] = Array(repeating: "", count: 6)
    @State private var showNewPassword = false
    @State private var showSuccess = false
    @State private var resendCooldown = false
    
    private var maskedEmail: String {
        let parts = email.split(separator: "@")
        guard let first = parts.first, first.count > 3 else { return email }
        let prefix = String(first.prefix(3))
        return "\(prefix)*******@\(parts.dropFirst().joined(separator: "@"))"
    }
    
    private var otpString: String {
        digits.joined()
    }
    
    var body: some View {
        VStack(spacing: 28) {
            Text("OTP Verification")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 32)
            
            Text("Please enter the verification code we've sent to \(maskedEmail)")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            OTPFieldView(digits: $digits)
                .padding(.horizontal, 24)
            
            PrimaryButton(title: "Verify") {
                if flow == .forgotPassword {
                    showNewPassword = true
                } else {
                    showSuccess = true
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            HStack(spacing: 4) {
                Text("Didn't receive an OTP?")
                    .foregroundColor(Theme.textSecondary)
                Button("Resend OTP") {
                    resendCooldown = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                        resendCooldown = false
                    }
                }
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .disabled(resendCooldown)
            }
            .font(.subheadline)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showNewPassword) {
            EnterNewPasswordView()
        }
        .navigationDestination(isPresented: $showSuccess) {
            SignInView()
        }
    }
}

//
//  CreateAccountView.swift
//  HospitalQueue
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var appState: AppState
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create an account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
                
                HStack(spacing: 12) {
                    socialButton(icon: "g.circle.fill", title: "Google")
                    socialButton(icon: "apple.logo", title: "Apple")
                }
                
                Text("OR")
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                
                StyledTextField(label: "Full Name", placeholder: "John Doe", text: $fullName)
                StyledTextField(label: "Phone Number", placeholder: "07XXXXXXX", text: $phoneNumber)
                StyledTextField(label: "Email", placeholder: "example@gmail.com", text: $email)
                StyledTextField(label: "Password", placeholder: "********", text: $password, isSecure: true)
                StyledTextField(label: "Confirm Password", placeholder: "********", text: $confirmPassword, isSecure: true)
                
                HStack(alignment: .top, spacing: 8) {
                    Button(action: { agreedToTerms.toggle() }) {
                        Image(systemName: agreedToTerms ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(agreedToTerms ? Theme.primaryGreen : Theme.textSecondary)
                    }
                    .buttonStyle(.plain)
                    Text("I agree to the terms of service")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                PrimaryButton(title: "Create Account") {
                    appState.userName = fullName.isEmpty ? "Sadew" : fullName
                    appState.isLoggedIn = true
                }
                .padding(.top, 8)
                
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundColor(Theme.textSecondary)
                    NavigationLink(destination: SignInView()) {
                        Text("Sign in")
                            .foregroundColor(.primary)
                            .fontWeight(.medium)
                    }
                }
                .font(.subheadline)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func socialButton(icon: String, title: String) -> some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.headline)
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.borderGray, lineWidth: 1))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

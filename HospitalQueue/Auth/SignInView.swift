//
//  SignInView.swift
//  HospitalQueue
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    @State private var showCreateAccount = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Welcome back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 32)
                    
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                Text("Google")
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
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "apple.logo")
                                Text("Apple")
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
                    
                    Text("OR")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                    
                    StyledTextField(label: "Email", placeholder: "example@gmail.com", text: $email)
                    StyledTextField(
                        label: "Password",
                        placeholder: "********",
                        text: $password,
                        isSecure: true,
                        showForgotPassword: true,
                        onForgotPassword: { showForgotPassword = true }
                    )
                    
                    PrimaryButton(title: "Sign In") {
                        appState.isLoggedIn = true
                    }
                    .padding(.top, 8)
                    
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(Theme.textSecondary)
                        Button("Create one") {
                            showCreateAccount = true
                        }
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationDestination(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
            .navigationDestination(isPresented: $showCreateAccount) {
                CreateAccountView()
            }
        }
    }
}

//
//  StyledTextField.swift
//  HospitalQueue
//

import SwiftUI

struct StyledTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var showForgotPassword: Bool = false
    var onForgotPassword: (() -> Void)?
    
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                if showForgotPassword {
                    Spacer()
                    Button("Forgot password?") {
                        onForgotPassword?()
                    }
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                }
            }
            if isSecure && !isPasswordVisible {
                SecureField(placeholder, text: $text)
                    .textContentType(.password)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Theme.borderGray, lineWidth: 1)
                    )
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: { isPasswordVisible = true }) {
                                Image(systemName: "eye.slash")
                                    .foregroundColor(Theme.textSecondary)
                                    .padding(.trailing, 12)
                            }
                        }
                    )
            } else if isSecure {
                HStack {
                    TextField(placeholder, text: $text)
                        .textContentType(.password)
                        .autocapitalization(.none)
                    Button(action: { isPasswordVisible = false }) {
                        Image(systemName: "eye")
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Theme.borderGray, lineWidth: 1)
                )
                .cornerRadius(10)
            } else {
                TextField(placeholder, text: $text)
                    .textContentType(label == "Email" ? .emailAddress : .none)
                    .autocapitalization(.none)
                    .keyboardType(label == "Email" ? .emailAddress : .default)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Theme.borderGray, lineWidth: 1)
                    )
                    .cornerRadius(10)
            }
        }
    }
}

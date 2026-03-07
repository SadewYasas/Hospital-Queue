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
        VStack(alignment: .leading, spacing: 8) {
            // Label row
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.primary)
                if showForgotPassword {
                    Spacer(minLength: 8)
                    Button("Forgot password?") {
                        onForgotPassword?()
                    }
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Theme.primaryGreen)
                    .buttonStyle(.plain)
                }
            }

            // Field container with refined styling
            Group {
                if isSecure && !isPasswordVisible {
                    ZStack {
                        // Background card
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color(UIColor.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color(UIColor.separator).opacity(0.5), lineWidth: 1)
                            )

                        HStack(spacing: 10) {
                            SecureField(placeholder, text: $text)
                                .textContentType(.password)
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                                .foregroundStyle(.primary)
                                .padding(.vertical, 12)
                                .padding(.leading, 14)

                            Spacer(minLength: 6)

                            Button(action: { isPasswordVisible = true }) {
                                Image(systemName: "eye.slash")
                                    .foregroundStyle(Theme.primaryGreen)
                                    .padding(10)
                                    .background(
                                        Circle().fill(Theme.primaryGreen.opacity(0.12))
                                    )
                            }
                            .padding(.trailing, 8)
                        }
                        .padding(.vertical, 2)
                    }
                    .frame(minHeight: 50)
                } else if isSecure {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color(UIColor.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color(UIColor.separator).opacity(0.5), lineWidth: 1)
                            )

                        HStack(spacing: 10) {
                            TextField(placeholder, text: $text)
                                .textContentType(.password)
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                                .foregroundStyle(.primary)
                                .padding(.vertical, 12)
                                .padding(.leading, 14)

                            Spacer(minLength: 6)

                            Button(action: { isPasswordVisible = false }) {
                                Image(systemName: "eye")
                                    .foregroundStyle(Theme.primaryGreen)
                                    .padding(10)
                                    .background(
                                        Circle().fill(Theme.primaryGreen.opacity(0.12))
                                    )
                            }
                            .padding(.trailing, 8)
                        }
                        .padding(.vertical, 2)
                    }
                    .frame(minHeight: 50)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color(UIColor.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color(UIColor.separator).opacity(0.5), lineWidth: 1)
                            )

                        HStack(spacing: 10) {
                            TextField(placeholder, text: $text)
                                .textContentType(label == "Email" ? .emailAddress : .none)
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                                .foregroundStyle(.primary)
                                .keyboardType(label == "Email" ? .emailAddress : .default)
                                .padding(.vertical, 12)
                                .padding(.leading, 14)
                        }
                        .padding(.vertical, 2)
                    }
                    .frame(minHeight: 50)
                }
            }
        }
    }
}

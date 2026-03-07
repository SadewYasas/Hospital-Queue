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
        ZStack {
            // MARK: - Background gradient with soft blobs
            LinearGradient(
                colors: [Color("GradientTop"), Color("GradientBottom")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // MARK: - Header
                    VStack(spacing: 8) {
                        Text("OTP Verification")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.green, Color.black],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Please enter the verification code we've sent to \(maskedEmail)")
                            .font(.subheadline)
                            .foregroundColor(Color("SecondaryText"))
                            .multilineTextAlignment(.center)
                            .opacity(0.85)
                            .padding(.horizontal)
                    }
                    .padding(.top, 120)
                    
                    // MARK: - OTP Field with glass effect
                    OTPFieldView(digits: $digits)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 24)
                    
                    // MARK: - Verify Button
                    PrimaryButton(title: "Verify") {
                        withAnimation(.spring()) {
                            if flow == .forgotPassword {
                                showNewPassword = true
                            } else {
                                showSuccess = true
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .shadow(color: Color.purple.opacity(0.3), radius: 12, x: 0, y: 6)
                    
                    // MARK: - Resend OTP
                    HStack(spacing: 4) {
                        Text("Didn't receive an OTP?")
                            .foregroundColor(Color("SecondaryText"))
                        
                        Button(action: {
                            resendCooldown = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                                resendCooldown = false
                            }
                        }) {
                            Text("Resend OTP")
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(
                            LinearGradient(colors: [Color.black, Color.gray], startPoint: .leading, endPoint: .trailing)
                        )
                        .disabled(resendCooldown)
                    }
                    .font(.subheadline)
                    
                    Spacer(minLength: 60)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showNewPassword) {
            EnterNewPasswordView()
        }
        .navigationDestination(isPresented: $showSuccess) {
            SignInView()
        }
    }
}

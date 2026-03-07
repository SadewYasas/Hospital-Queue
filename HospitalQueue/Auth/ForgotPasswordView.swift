import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showOTP = false
    
    var body: some View {
        ZStack {
            // MARK: - Background Gradient
            LinearGradient(
                colors: [Color("GradientTop"), Color("GradientBottom")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Forgot Password?")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.black, Color.green],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Enter your email address and we'll send you recovery instructions.")
                            .font(.subheadline)
                            .foregroundColor(Color("SecondaryText"))
                            .opacity(0.85)
                    }
                    .padding(.top, 120)
                    
                    // MARK: - Email Field with Glass Effect
                    StyledTextField(label: "Email", placeholder: "example@gmail.com", text: $email)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    // MARK: - Send Button
                    PrimaryButton(title: "Send") {
                        withAnimation(.spring()) {
                            showOTP = true
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 16)
                    .buttonStyle(.borderless)
                    .shadow(color: Color.purple.opacity(0.3), radius: 12, x: 0, y: 6)
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showOTP) {
            OTPVerificationView(email: email, flow: .forgotPassword)
        }
    }
}

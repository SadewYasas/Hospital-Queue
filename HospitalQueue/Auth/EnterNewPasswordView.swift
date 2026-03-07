import SwiftUI

struct EnterNewPasswordView: View {
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showSuccess = false
    
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
                        Text("Enter New Password")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.green, Color.black],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("You have been verified! Set your new password below.")
                            .font(.subheadline)
                            .foregroundColor(Color("SecondaryText"))
                            .opacity(0.85)
                    }
                    .padding(.top, 120)
                    
                    // MARK: - Password Fields (Glassmorphic)
                    VStack(spacing: 16) {
                        StyledTextField(label: "New Password", placeholder: "********", text: $newPassword, isSecure: true)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        StyledTextField(label: "Confirm Password", placeholder: "********", text: $confirmPassword, isSecure: true)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 24)
                    
                    // MARK: - Confirm Button
                    PrimaryButton(title: "Confirm Change") {
                        withAnimation(.spring()) {
                            showSuccess = true
                        }
                    }
                    .padding(.horizontal, 24)
                    .shadow(color: Color.purple.opacity(0.3), radius: 12, x: 0, y: 6)
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showSuccess) {
            PasswordResetSuccessView()
        }
    }
}

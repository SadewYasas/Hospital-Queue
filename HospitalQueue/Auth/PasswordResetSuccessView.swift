import SwiftUI

struct PasswordResetSuccessView: View {
    @EnvironmentObject var appState: AppState
    @State private var goToSignIn = false
    @State private var animateCheck = false
    
    var body: some View {
        ZStack {
            // MARK: - Background Gradient
            LinearGradient(
                colors: [Color("GradientTop"), Color("GradientBottom")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // MARK: - Header
                VStack(spacing: 8) {
                    Text("Success!")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.green, Color.gray],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .scaleEffect(animateCheck ? 1.05 : 1)
                        .animation(.spring(response: 0.5, dampingFraction: 0.5), value: animateCheck)
                    
                    Text("Your password has been successfully reset!")
                        .font(.subheadline)
                        .foregroundColor(Color("SecondaryText"))
                        .multilineTextAlignment(.center)
                        .opacity(0.85)
                        .padding(.horizontal)
                       
                }
                .padding(.top, 120)
                Text("Your Password changed Successfully!")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Color.gray.opacity(0.8)) // you can adjust opacity
                    .multilineTextAlignment(.center)
                
                // MARK: - Animated Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Theme.primaryGreen)
                    .symbolRenderingMode(.hierarchical)
                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
                
                
                    .scaleEffect(animateCheck ? 1 : 0.7)
                    .opacity(animateCheck ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: animateCheck)
                    .padding(.top, 16)
                    .onAppear {
                        animateCheck = true
                    }
                
                // MARK: - Continue Button (Glassmorphic style)
                PrimaryButton(title: "Continue to Log In") {
                    withAnimation(.spring()) {
                        goToSignIn = true
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .shadow(color: Color.green.opacity(0.3), radius: 12, x: 0, y: 6)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToSignIn) {
            SignInView()
        }
    }
}

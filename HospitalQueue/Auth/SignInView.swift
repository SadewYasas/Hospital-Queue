import SwiftUI

struct SignInView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    @State private var showCreateAccount = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {

                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(Color("PrimaryText")) // High-contrast, modern color
                        Text("Sign in to continue to HospitalQueue")
                            .font(.subheadline)
                            .foregroundColor(Color("SecondaryText"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 60)

                    // MARK: - Social Login Buttons
                    HStack(spacing: 12) {
                        SocialLoginButton(title: "Google", icon: "g.circle.fill", bgColor: .white, fgColor: .black)
                        SocialLoginButton(title: "Apple", icon: "apple.logo", bgColor: .black, fgColor: .white)
                    }

                    // MARK: - OR Divider
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                        Text("OR")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(Color.gray)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                    }

                    // MARK: - Form Card
                    VStack(spacing: 20) {
                        StyledTextField(label: "Email", placeholder: "example@gmail.com", text: $email)
                        StyledTextField(
                            label: "Password",
                            placeholder: "********",
                            text: $password,
                            isSecure: true,
                            showForgotPassword: true,
                            onForgotPassword: { showForgotPassword = true }
                        )
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
                    )

                    // MARK: - Sign In Button
                    PrimaryButton(title: "Sign In") {
                        appState.isLoggedIn = true
                    }
                    .padding(.top, 8)
                    .buttonStyle(.borderless)
                    .shadow(color: Color.blue.opacity(0.25), radius: 8, x: 0, y: 4)

                    // MARK: - Create Account Link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(Color.gray)
                        NavigationLink(destination: CreateAccountView()) {
                            Text("Create one")
                                .foregroundColor(Color.blue)
                                .fontWeight(.semibold)
                        }
                    }
                    .font(.subheadline)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(
                LinearGradient(
                    colors: [Color("BackgroundTop"), Color("BackgroundBottom")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .navigationDestination(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}

// MARK: - Social Login Button Component
struct SocialLoginButton: View {
    let title: String
    let icon: String
    let bgColor: Color
    let fgColor: Color

    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.headline)
            .foregroundColor(fgColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(bgColor)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}

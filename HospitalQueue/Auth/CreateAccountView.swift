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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // MARK: - Header
                Text("Create an account")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color("PrimaryText"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, -20)

                // MARK: - Social Buttons
                HStack(spacing: 12) {
                    socialButton(icon: "g.circle.fill", title: "Google", bgColor: .white, fgColor: .black)
                    socialButton(icon: "apple.logo", title: "Apple", bgColor: .black, fgColor: .white)
                }

                // MARK: - OR Divider
                HStack {
                    Divider().background(Color.gray.opacity(0.3))
                    Text("OR")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Color.gray)
                    Divider().background(Color.gray.opacity(0.3))
                }

                // MARK: - Form Fields
                VStack(spacing: 16) {
                    StyledTextField(label: "Full Name", placeholder: "John Doe", text: $fullName)
                    StyledTextField(label: "Phone Number", placeholder: "07XXXXXXX", text: $phoneNumber)
                    StyledTextField(label: "Email", placeholder: "example@gmail.com", text: $email)
                    StyledTextField(label: "Password", placeholder: "********", text: $password, isSecure: true)
                    StyledTextField(label: "Confirm Password", placeholder: "********", text: $confirmPassword, isSecure: true)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
                )

                // MARK: - Terms Checkbox
                HStack(alignment: .top, spacing: 8) {
                    Button(action: { agreedToTerms.toggle() }) {
                        Image(systemName: agreedToTerms ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(agreedToTerms ? Color.green : Color.gray)
                            .font(.title3)
                            .scaleEffect(agreedToTerms ? 1.1 : 1.0)
                            .animation(.spring(), value: agreedToTerms)
                    }
                    .buttonStyle(.plain)

                    Text("I agree to the terms of service")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: - Create Account Button
                PrimaryButton(title: "Create Account") {
                    appState.userName = fullName.isEmpty ? "Sadew" : fullName
                    appState.isLoggedIn = true
                }
                .padding(.top, 8)
                .shadow(color: Color.blue.opacity(0.25), radius: 8, x: 0, y: 4)

                // MARK: - Sign In Link
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundColor(Color.gray)
                    NavigationLink(destination: SignInView()) {
                        Text("Sign in")
                            .foregroundColor(Color.blue)
                            .fontWeight(.semibold)
                    }
                }
                .font(.subheadline)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .background(
            LinearGradient(
                colors: [Color("BackgroundTop"), Color("BackgroundBottom")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Social Button
    private func socialButton(icon: String, title: String, bgColor: Color, fgColor: Color) -> some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .fontWeight(.medium)
            }
            .foregroundColor(fgColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(bgColor)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var animateHero = false
    @State private var heroFloat = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemTeal).opacity(0.06), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer(minLength: 24)

                // Hero card with float animation and soft accents
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.linearGradient(colors: [Color(.systemTeal).opacity(0.12), .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 160)
                        .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)

                    // soft decorative circles
                    Circle()
                        .fill(Color(.systemTeal).opacity(0.08))
                        .frame(width: 88, height: 88)
                        .offset(x: -120, y: -30)

                    Circle()
                        .fill(Color(.systemBlue).opacity(0.06))
                        .frame(width: 56, height: 56)
                        .offset(x: 110, y: 40)

                    HStack(spacing: 16) {
                        Image(systemName: "cross.case.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                            .foregroundColor(Color(.systemTeal))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hospital Queue")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("Fast • Fair • Friendly")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal)
                .scaleEffect(animateHero ? 1.0 : 0.98)
                .offset(y: heroFloat ? -6 : 6)
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: heroFloat)
                .onAppear {
                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 18).delay(0.08)) {
                        animateHero = true
                    }
                    heroFloat = true
                }

                // Sign-in controls
                VStack(spacing: 12) {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            auth.handleAuthorization(authorization)
                        case .failure(let error):
                            print("Apple sign-in failed: \(error.localizedDescription)")
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 54)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
                    .buttonStyle(.animated)

                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        auth.handleGoogleSignInPlaceholder()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "globe")
                                .font(.title2)
                            Text("Continue with Google")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color(.systemBlue).opacity(0.18), radius: 10, x: 0, y: 6)
                    }
                    .buttonStyle(.animated)

                    HStack {
                        Rectangle().frame(height: 1).foregroundColor(Color.gray.opacity(0.2))
                        Text("or")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Rectangle().frame(height: 1).foregroundColor(Color.gray.opacity(0.2))
                    }
                    .padding(.vertical, 4)

                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        auth.userName = "Guest"
                        auth.isSignedIn = true
                    }) {
                        Text("Continue as Guest")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(.systemGray6))
                            .foregroundColor(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.animated)
                }
                .padding(.horizontal)

                Spacer()

                // Terms / small explanatory text
                VStack(spacing: 6) {
                    Text("By continuing, you agree to our Terms of Service and Privacy Policy.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                }

                Spacer(minLength: 8)
            }
            .padding(.vertical)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AuthViewModel())
            .previewDevice("iPhone 14")
    }
}

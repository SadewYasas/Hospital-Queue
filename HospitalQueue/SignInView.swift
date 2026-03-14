import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var animateHero = false
    @State private var heroFloat = false
    // Phone sign-in (demo OTP)
    @State private var phoneNumber = ""
    @State private var otpCode = ""
    @State private var phoneError: String?
    @State private var otpError: String?
    @State private var showOTPEntry = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBlue).opacity(0.12), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    heroCard

                    phoneSignInForm

                    dividerWithOr

                    socialAndGuestButtons
            }
                .padding(.horizontal)
                .padding(.top, 48)
                .padding(.bottom, 20)
            }

            termsFooter
        }
    }

    private var heroCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.linearGradient(colors: [Color(.systemTeal).opacity(0.12), .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 140)
                .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)

            Circle()
                .fill(Color(.systemTeal).opacity(0.08))
                .frame(width: 88, height: 88)
                .offset(x: -100, y: -20)
            Circle()
                .fill(Color(.systemBlue).opacity(0.06))
                .frame(width: 56, height: 56)
                .offset(x: 90, y: 30)

            HStack(spacing: 16) {
                Image(systemName: "cross.case.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
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
        .offset(y: heroFloat ? -4 : 4)
        .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: heroFloat)
        .onAppear {
            withAnimation(Animation.iosEntrance.delay(0.06)) { animateHero = true }
            heroFloat = true
        }
    }

    private var phoneSignInForm: some View {
        VStack(spacing: 16) {
            Text("Sign in with phone")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Phone number", text: $phoneNumber)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .onChange(of: phoneNumber) { _ in
                    if phoneError != nil { phoneError = nil }
                }

            if let err = phoneError {
                Text(err)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if auth.isOTPRequested {
                Text("We’ve sent a 6-digit code to your phone.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Button("Enter code") {
                        otpCode = ""
                        otpError = nil
                        showOTPEntry = true
                    }
                    .font(.subheadline)
                    .foregroundColor(Color(.systemTeal))

                    Spacer()

                    Button("Change number") {
                        otpCode = ""
                        otpError = nil
                        phoneError = nil
                        auth.resetPhoneOTPFlow()
                    }
                    .font(.subheadline)
                    .foregroundColor(Color(.systemTeal))
                }
            }

            Button(action: performSendOTP) {
                Text(auth.isOTPRequested ? "Resend OTP" : "Send OTP")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.animated)
        }
        .sheet(isPresented: $showOTPEntry) {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Enter verification code")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Type the 6-digit code we sent to your phone.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TextField("6-digit code", text: $otpCode)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .onChange(of: otpCode) { _ in
                            if otpError != nil { otpError = nil }
                        }

                    if let err = otpError {
                        Text(err)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Spacer()

                    Button(action: {
                        performVerifyOTP()
                        if otpError == nil {
                            showOTPEntry = false
                        }
                    }) {
                        Text("Verify & Continue")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.animated)
                }
                .padding(24)
                .navigationTitle("Verify OTP")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    private func performSendOTP() {
        otpError = nil
        otpCode = ""
        let error = auth.requestOTP(for: phoneNumber)
        phoneError = error
        if error == nil {
            showOTPEntry = true
        }
    }

    private func performVerifyOTP() {
        phoneError = nil
        otpError = auth.verifyOTP(otpCode)
        if otpError == nil {
            otpCode = ""
            phoneNumber = ""
        }
    }

    private var dividerWithOr: some View {
        HStack {
            Rectangle().frame(height: 1).foregroundColor(Color.gray.opacity(0.2))
            Text("or")
                .font(.caption)
                .foregroundColor(.secondary)
            Rectangle().frame(height: 1).foregroundColor(Color.gray.opacity(0.2))
        }
        .padding(.vertical, 4)
    }

    private var socialAndGuestButtons: some View {
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
            .signInWithAppleButtonStyle(.whiteOutline)
            .frame(height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )

            Button(action: {
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
            }
            .buttonStyle(.animated)

            Button(action: {
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
    }

    private var termsFooter: some View {
        VStack {
            Spacer()
            Text("By continuing, you agree to our Terms of Service and Privacy Policy.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
        }
        .allowsHitTesting(false)
    }
}
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AuthViewModel())
            .previewDevice("iPhone 14")
    }
}

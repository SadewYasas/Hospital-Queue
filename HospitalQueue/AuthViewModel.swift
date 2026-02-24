import Foundation
import AuthenticationServices
import Combine

final class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var userName: String = ""
    @Published var selectedService: String = ""
    @Published var currentToken: String = ""
    @Published var peopleAhead: Int = 0
    @Published var estimatedWaitMinutes: Int = 0
    @Published var counters: [String] = []

    func handleAuthorization(_ authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let given = credential.fullName?.givenName ?? ""
            let family = credential.fullName?.familyName ?? ""
            let fullName = [given, family].filter { !$0.isEmpty }.joined(separator: " ")
            DispatchQueue.main.async {
                self.isSignedIn = true
                if !fullName.isEmpty {
                    self.userName = fullName
                } else if let email = credential.email {
                    self.userName = email
                } else {
                    self.userName = credential.user
                }
            }
        }
    }

    func signOut() {
        DispatchQueue.main.async {
            self.isSignedIn = false
            self.userName = ""
            self.selectedService = ""
            self.currentToken = ""
            self.peopleAhead = 0
            self.estimatedWaitMinutes = 0
            self.counters = []
        }
    }

    // Placeholder for Google sign-in integration; replace with real SDK calls.
    func handleGoogleSignInPlaceholder() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.isSignedIn = true
            self.userName = "Google User"
        }
    }

    // Generate a simple token and populate queue metadata
    func generateToken(for service: String) {
        let prefix = service.split(separator: " ").first?.prefix(1).uppercased() ?? "A"
        let number = String(format: "%03d", Int.random(in: 1...999))
        let token = "\(prefix)-\(number)"

        DispatchQueue.main.async {
            self.selectedService = service
            self.currentToken = token
            self.peopleAhead = Int.random(in: 1...12)
            self.estimatedWaitMinutes = Int.random(in: 5...45)
            // example live counters
            self.counters = ["Counter 1: A - 073", "Counter 2: A - 070", "Counter 3: A - 065"]
        }
    }
}

import Foundation
import AuthenticationServices
import Combine
import UserNotifications

struct Appointment: Identifiable {
    let id: UUID
    let doctor: String
    let time: String
    let venue: String
    let category: String
    let dateCreated: Date

    init(id: UUID = UUID(), doctor: String, time: String, venue: String, category: String, dateCreated: Date = Date()) {
        self.id = id
        self.doctor = doctor
        self.time = time
        self.venue = venue
        self.category = category
        self.dateCreated = dateCreated
    }
}

private struct AppointmentCodable: Codable {
    let id: String
    let doctor: String
    let time: String
    let venue: String
    let category: String
    let dateCreated: TimeInterval

    init(from a: Appointment) {
        id = a.id.uuidString
        doctor = a.doctor
        time = a.time
        venue = a.venue
        category = a.category
        dateCreated = a.dateCreated.timeIntervalSince1970
    }

    func toAppointment() -> Appointment {
        Appointment(
            id: UUID(uuidString: id) ?? UUID(),
            doctor: doctor,
            time: time,
            venue: venue,
            category: category,
            dateCreated: Date(timeIntervalSince1970: dateCreated)
        )
    }
}

/// Simple account record for local demo (assumes backend exists).
private struct StoredAccount: Codable {
    let email: String
    let name: String
}

final class AuthViewModel: ObservableObject {
    private let userAddressKey = "HospitalQueue.userAddress"
    private let appointmentsKey = "HospitalQueue.appointments"
    private let accountsKey = "HospitalQueue.accounts"
    private let scheduledNextServiceKey = "HospitalQueue.scheduledNextService"
    private let scheduledNextDateKey = "HospitalQueue.scheduledNextDate"

    @Published var isSignedIn: Bool = false
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var userAddress: String = ""
    @Published var selectedService: String = ""
    @Published var currentToken: String = ""
    @Published var peopleAhead: Int = 0
    @Published var estimatedWaitMinutes: Int = 0
    @Published var counters: [String] = []
    @Published var appointments: [Appointment] = []

    // MARK: - Phone OTP (demo)
    @Published var isOTPRequested: Bool = false
    @Published private(set) var pendingPhoneNumber: String = ""

    init() {
        userAddress = UserDefaults.standard.string(forKey: userAddressKey) ?? ""
        loadAppointments()
    }

    private func loadAppointments() {
        guard let data = UserDefaults.standard.data(forKey: appointmentsKey),
              let decoded = try? JSONDecoder().decode([AppointmentCodable].self, from: data) else { return }
        appointments = decoded.map { $0.toAppointment() }
    }

    private func saveAppointments() {
        let codables = appointments.map { AppointmentCodable(from: $0) }
        guard let data = try? JSONEncoder().encode(codables) else { return }
        UserDefaults.standard.set(data, forKey: appointmentsKey)
    }

    func updateAddress(_ value: String) {
        userAddress = value
        UserDefaults.standard.set(value, forKey: userAddressKey)
    }

    func addAppointment(doctor: String, time: String, venue: String, category: String) {
        let appointment = Appointment(doctor: doctor, time: time, venue: venue, category: category)
        appointments.insert(appointment, at: 0)
        saveAppointments()
    }

    // MARK: - Email / password (assume backend; validate locally)

    /// Returns nil if valid, or an error message.
    static func validateEmail(_ email: String) -> String? {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "Enter your email" }
        let parts = trimmed.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2, parts[0].count > 0, parts[1].contains("."), parts[1].count >= 4 else {
            return "Enter a valid email address"
        }
        return nil
    }

    /// Returns nil if valid, or an error message. For sign up (strength rules).
    static func validatePasswordSignUp(_ password: String) -> String? {
        guard password.count >= 8 else { return "Password must be at least 8 characters" }
        guard password.contains(where: { $0.isLetter }) else { return "Password must contain at least one letter" }
        guard password.contains(where: { $0.isNumber }) else { return "Password must contain at least one number" }
        return nil
    }

    /// For sign in, just non-empty.
    static func validatePasswordSignIn(_ password: String) -> String? {
        guard !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return "Enter your password" }
        return nil
    }

    private func loadAccounts() -> [StoredAccount] {
        guard let data = UserDefaults.standard.data(forKey: accountsKey),
              let decoded = try? JSONDecoder().decode([StoredAccount].self, from: data) else { return [] }
        return decoded
    }

    private func saveAccount(email: String, name: String) {
        var accounts = loadAccounts()
        accounts.removeAll { $0.email.lowercased() == email.lowercased() }
        accounts.append(StoredAccount(email: email, name: name))
        guard let data = try? JSONEncoder().encode(accounts) else { return }
        UserDefaults.standard.set(data, forKey: accountsKey)
    }

    /// Sign in with email and password. Assumes backend accepts. Returns error message or nil.
    func signInWithEmail(email: String, password: String) -> String? {
        if let e = AuthViewModel.validateEmail(email) { return e }
        if let e = AuthViewModel.validatePasswordSignIn(password) { return e }
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let accounts = loadAccounts()
        let name = accounts.first { $0.email.lowercased() == trimmedEmail }?.name
            ?? String(trimmedEmail.split(separator: "@").first ?? "User")
        DispatchQueue.main.async {
            self.userEmail = trimmedEmail
            self.userName = name
            self.isSignedIn = true
        }
        return nil
    }

    /// Sign up with name, email, password. Assumes backend accepts. Returns error message or nil.
    func signUpWithEmail(name: String, email: String, password: String) -> String? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return "Enter your name" }
        if let e = AuthViewModel.validateEmail(email) { return e }
        if let e = AuthViewModel.validatePasswordSignUp(password) { return e }
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        saveAccount(email: trimmedEmail, name: trimmedName)
        DispatchQueue.main.async {
            self.userEmail = trimmedEmail
            self.userName = trimmedName
            self.isSignedIn = true
        }
        return nil
    }

    // MARK: - Phone OTP (demo)

    /// Returns nil if valid, or an error message.
    static func validatePhoneNumber(_ phone: String) -> String? {
        let digits = phone.filter(\.isNumber)
        guard !digits.isEmpty else { return "Enter your phone number" }
        guard digits.count >= 8 else { return "Enter a valid phone number" }
        return nil
    }

    /// Demo: "requests" OTP and allows any 6-digit code for verification.
    /// Returns an error message (if any), or nil on success.
    func requestOTP(for phone: String) -> String? {
        if let e = AuthViewModel.validatePhoneNumber(phone) { return e }
        let normalized = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        DispatchQueue.main.async {
            self.pendingPhoneNumber = normalized
            self.isOTPRequested = true
        }
        return nil
    }

    /// Demo: accepts any 6 digits. Returns error message or nil.
    func verifyOTP(_ code: String) -> String? {
        guard isOTPRequested else { return "Request an OTP first" }
        let digits = code.filter(\.isNumber)
        guard digits.count == 6 else { return "Enter a 6-digit OTP" }
        DispatchQueue.main.async {
            self.userEmail = ""
            self.userName = self.maskedPhoneDisplay(self.pendingPhoneNumber)
            self.isSignedIn = true
            self.isOTPRequested = false
            self.pendingPhoneNumber = ""
        }
        return nil
    }

    func resetPhoneOTPFlow() {
        DispatchQueue.main.async {
            self.isOTPRequested = false
            self.pendingPhoneNumber = ""
        }
    }

    private func maskedPhoneDisplay(_ phone: String) -> String {
        let digits = phone.filter(\.isNumber)
        if digits.count <= 4 {
            return phone.isEmpty ? "Phone User" : phone
        }
        let last4 = digits.suffix(4)
        return "••• ••• \(last4)"
    }

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
            self.userEmail = ""
            self.userAddress = ""
            UserDefaults.standard.removeObject(forKey: self.userAddressKey)
            self.selectedService = ""
            self.currentToken = ""
            self.peopleAhead = 0
            self.estimatedWaitMinutes = 0
            self.counters = []
            self.appointments = []
            UserDefaults.standard.removeObject(forKey: self.appointmentsKey)
        }
    }

    // Placeholder for Google sign-in integration; replace with real SDK calls.
    func handleGoogleSignInPlaceholder() {
        DispatchQueue.main.async {
            self.isSignedIn = true
            self.userName = "Google User"
        }
    }

    /// Clears the active queue state (e.g. after visit is complete). Resets token, queue position, etc.
    func clearActiveQueue() {
        DispatchQueue.main.async {
            self.currentToken = ""
            self.peopleAhead = 0
            self.estimatedWaitMinutes = 0
            self.counters = []
            self.selectedService = ""
        }
    }

    // MARK: - Next appointment (fixed sequence) + scheduling

    func nextService(after current: String) -> String? {
        let normalized = current.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return nil }

        // Keep this simple/editable. Keys should match what we store in `selectedService`.
        let map: [String: String] = [
            "OCD/Consultant": "Pharmacy",
            "Doctor": "Pharmacy",
            "Doctor Appointment": "Pharmacy",
            "Pharmacy": "Admission",
            "Admission": "Emergency",
            "Emergency": nil
        ].compactMapValues { $0 }

        return map[normalized]
    }

    /// Persist a scheduled token generation for a service.
    func scheduleNextToken(for service: String, at date: Date) {
        let trimmed = service.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        UserDefaults.standard.set(trimmed, forKey: scheduledNextServiceKey)
        UserDefaults.standard.set(date.timeIntervalSince1970, forKey: scheduledNextDateKey)
        scheduleLocalNotification(for: trimmed, at: date)
    }

    func clearScheduledNextToken() {
        UserDefaults.standard.removeObject(forKey: scheduledNextServiceKey)
        UserDefaults.standard.removeObject(forKey: scheduledNextDateKey)
    }

    /// If a scheduled token is due, generate it and clear the schedule. Returns the service generated.
    @discardableResult
    func consumeScheduledTokenIfDue(now: Date = Date()) -> String? {
        guard let service = UserDefaults.standard.string(forKey: scheduledNextServiceKey) else { return nil }
        let ts = UserDefaults.standard.double(forKey: scheduledNextDateKey)
        guard ts > 0 else { return nil }

        let scheduledDate = Date(timeIntervalSince1970: ts)
        guard scheduledDate <= now else { return nil }

        clearScheduledNextToken()
        generateToken(for: service, immediateTurn: false)
        return service
    }

    private func scheduleLocalNotification(for service: String, at date: Date) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in
            let content = UNMutableNotificationContent()
            content.title = "Next appointment"
            content.body = "Your next appointment is \(service)."
            content.sound = .default

            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let request = UNNotificationRequest(
                identifier: "HospitalQueue.nextAppointment.\(service)",
                content: content,
                trigger: trigger
            )
            center.add(request, withCompletionHandler: nil)
        }
    }

    // Generate a simple token and populate queue metadata
    /// When `immediateTurn` is true, wait time is 0 and user goes to "It's your turn" flow.
    func generateToken(for service: String, immediateTurn: Bool = false) {
        let prefix = service.split(separator: " ").first?.prefix(1).uppercased() ?? "A"
        let number = String(format: "%03d", Int.random(in: 1...999))
        let token = "\(prefix)-\(number)"

        DispatchQueue.main.async {
            self.selectedService = service
            self.currentToken = token
            if immediateTurn {
                self.peopleAhead = 0
                self.estimatedWaitMinutes = 0
                self.counters = ["Counter 1: Your turn now", "Counter 2: A - 070", "Counter 3: A - 065"]
            } else {
                self.peopleAhead = Int.random(in: 1...12)
                self.estimatedWaitMinutes = Int.random(in: 5...45)
                self.counters = ["Counter 1: A - 073", "Counter 2: A - 070", "Counter 3: A - 065"]
            }
        }
    }
}

//
//  AppState.swift
//  HospitalQueue
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet { UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn") }
    }
    @Published var userName: String {
        didSet { UserDefaults.standard.set(userName, forKey: "userName") }
    }
    @Published var hasSeenWelcome: Bool {
        didSet { UserDefaults.standard.set(hasSeenWelcome, forKey: "hasSeenWelcome") }
    }
    
    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? "Sadew"
        self.hasSeenWelcome = UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    }
    
    func logout() {
        isLoggedIn = false
        hasSeenWelcome = false
    }
    
    func completeWelcome() {
        hasSeenWelcome = true
    }
}

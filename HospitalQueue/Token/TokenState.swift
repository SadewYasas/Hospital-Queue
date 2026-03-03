//
//  TokenState.swift
//  HospitalQueue
//

import SwiftUI

final class TokenState: ObservableObject {
    static let shared = TokenState()
    
    @Published var currentToken: String = "A - 075"
    @Published var peopleAhead: Int = 5
    @Published var estimatedWaitMinutes: Int = 30
    @Published var queueBadge: QueueBadge = .getReady
    @Published var counterServing: [String] = ["A - 073", "A - 070", "A - 065", "A - 078"]
    @Published var myCounterNumber: Int = 3
    @Published var selectedService: WalkInService = .emergency
    @Published var showTokenGenerated = false
    
    enum QueueBadge: String {
        case longWait = "Long Wait"
        case soon = "Soon"
        case getReady = "Get Ready"
    }
    
    func generateToken() {
        let letters = ["A", "B", "C"]
        let letter = letters.randomElement() ?? "A"
        let num = Int.random(in: 60...90)
        currentToken = "\(letter) - \(String(format: "%03d", num))"
        peopleAhead = Int.random(in: 2...15)
        estimatedWaitMinutes = peopleAhead * 2 + Int.random(in: 5...15)
        queueBadge = peopleAhead > 8 ? .longWait : (peopleAhead > 3 ? .soon : .getReady)
        myCounterNumber = Int.random(in: 1...4)
        counterServing = (1...4).map { _ in
            "\(letters.randomElement() ?? "A") - \(String(format: "%03d", Int.random(in: 60...85)))"
        }
    }
    
    func clearToken() {
        currentToken = ""
        showTokenGenerated = false
    }
}

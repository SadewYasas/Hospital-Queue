//
//  Theme.swift
//  HospitalQueue
//

import SwiftUI

enum Theme {
    static let primaryGreen = Color(red: 0.2, green: 0.75, blue: 0.4)
    static let primaryGreenDark = Color(red: 0.15, green: 0.65, blue: 0.35)
    
    static let tokenGradientStart = Color(red: 0.2, green: 0.6, blue: 0.65)
    static let tokenGradientEnd = Color(red: 0.35, green: 0.75, blue: 0.6)
    
    static let queueCardPink = Color(red: 1.0, green: 0.92, blue: 0.93)
    static let queueCardGreen = Color(red: 0.85, green: 0.95, blue: 0.88)
    static let queueBadgeOrange = Color(red: 1.0, green: 0.8, blue: 0.6)
    
    static let endSessionRed = Color(red: 0.7, green: 0.2, blue: 0.2)
    
    static let borderGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    
    static var tokenCardGradient: LinearGradient {
        LinearGradient(
            colors: [tokenGradientStart, tokenGradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

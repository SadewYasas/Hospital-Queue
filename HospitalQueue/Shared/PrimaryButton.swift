//
//  PrimaryButton.swift
//  HospitalQueue
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.primaryGreen)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.primaryGreen)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.primaryGreen, lineWidth: 2)
                )
                .background(Color.white)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

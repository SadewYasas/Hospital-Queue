//
//  EndSessionView.swift
//  HospitalQueue
//

import SwiftUI

struct EndSessionView: View {
    @StateObject private var tokenState = TokenState.shared
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 32) {
            ProgressView()
                .scaleEffect(3)
                .padding(.top, 250)
            Text("Processing...")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Button(action: {
                tokenState.clearToken()
                dismiss()
            }) {
                Text("End Session")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.endSessionRed)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

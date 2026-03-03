//
//  QueueStatusView.swift
//  HospitalQueue
//

import SwiftUI

struct QueueStatusView: View {
    @StateObject private var tokenState = TokenState.shared
    @State private var showYourTurn = false
    @State private var simulateTurn = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                tokenCard
                queueProgressCard
                liveCounterSection
                if simulateTurn {
                    PrimaryButton(title: "Simulate my turn") {
                        showYourTurn = true
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Queue Status")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(Theme.primaryGreen)
                }
            }
        }
        .navigationDestination(isPresented: $showYourTurn) {
            ItsYourTurnView()
        }
        .onAppear {
            simulateTurn = true
        }
    }
    
    private var tokenCard: some View {
        VStack(spacing: 4) {
            Text("Token Number")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            Text(tokenState.currentToken)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Theme.tokenCardGradient)
        .cornerRadius(16)
    }
    
    private var queueProgressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("People ahead")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Text("\(tokenState.peopleAhead)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer()
                Text(tokenState.queueBadge.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(badgeColor)
                    .cornerRadius(12)
            }
            ProgressView(value: progressValue)
                .tint(Theme.primaryGreen)
            Text("Estimated Wait: \(tokenState.estimatedWaitMinutes) Minutes")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .padding(16)
        .background(Theme.queueCardGreen)
        .cornerRadius(16)
    }
    
    private var badgeColor: Color {
        switch tokenState.queueBadge {
        case .longWait: return Theme.queueCardPink
        case .soon: return Theme.primaryGreen
        case .getReady: return Theme.queueBadgeOrange
        }
    }
    
    private var progressValue: Double {
        let total = 20.0
        let remaining = Double(tokenState.peopleAhead)
        return max(0, (total - remaining) / total)
    }
    
    private var liveCounterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live Counter Status")
                .font(.headline)
                .foregroundColor(.primary)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Array(tokenState.counterServing.enumerated()), id: \.offset) { index, token in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Counter \(index + 1)")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                        Text("Now serving")
                            .font(.caption2)
                            .foregroundColor(Theme.textSecondary)
                        Text(token)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(12)
                }
            }
        }
    }
}

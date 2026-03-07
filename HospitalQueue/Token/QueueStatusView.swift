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

            VStack(spacing: 24) {

                tokenCard

                queueProgressCard

                liveCounterSection

                if simulateTurn {
                    PrimaryButton(title: "Simulate my turn") {
                        showYourTurn = true
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)

        .background(
            LinearGradient(
                colors: [
                    Color(UIColor.systemGroupedBackground),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )

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

    // MARK: TOKEN CARD

    private var tokenCard: some View {

        VStack(spacing: 6) {

            Text("Token Number")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))

            Text(tokenState.currentToken)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)

        .background(
            LinearGradient(
                colors: [
                    Theme.tokenGradientStart,
                    Theme.tokenGradientEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )

        .cornerRadius(20)

        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )

        .shadow(
            color: Color.black.opacity(0.08),
            radius: 20,
            x: 0,
            y: 10
        )
    }

    // MARK: QUEUE PROGRESS CARD

    private var queueProgressCard: some View {

        VStack(alignment: .leading, spacing: 14) {

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

                queueBadge
            }

            ProgressView(value: progressValue)
                .tint(Theme.primaryGreen)

            Text("Estimated Wait: \(tokenState.estimatedWaitMinutes) Minutes")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .padding(16)

        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )

        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )

        .shadow(
            color: Color.black.opacity(0.05),
            radius: 12,
            x: 0,
            y: 6
        )
    }

    // MARK: BADGE

    private var queueBadge: some View {

        HStack(spacing: 6) {

            Circle()
                .fill(badgeForegroundColor)
                .frame(width: 8, height: 8)

            Text(tokenState.queueBadge.rawValue)
                .font(.caption.weight(.semibold))
                .foregroundStyle(badgeForegroundColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)

        .background(
            Capsule()
                .fill(badgeBackgroundColor)
        )
    }

    // MARK: COUNTER SECTION

    private var liveCounterSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Live Counter Status")
                .font(.headline)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {

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

                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                    )

                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.black.opacity(0.04), lineWidth: 1)
                    )

                    .shadow(
                        color: Color.black.opacity(0.05),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                }
            }
        }
    }

    // MARK: COLORS

    private var badgeBackgroundColor: Color {

        switch tokenState.queueBadge {

        case .longWait:
            return Theme.queueCardPink.opacity(0.15)

        case .soon:
            return Theme.primaryGreen.opacity(0.15)

        case .getReady:
            return Theme.queueBadgeOrange.opacity(0.15)
        }
    }

    private var badgeForegroundColor: Color {

        switch tokenState.queueBadge {

        case .longWait:
            return Theme.queueCardPink

        case .soon:
            return Theme.primaryGreen

        case .getReady:
            return Theme.queueBadgeOrange
        }
    }

    // MARK: PROGRESS

    private var progressValue: Double {

        let total = 20.0
        let remaining = Double(tokenState.peopleAhead)

        return max(0, (total - remaining) / total)
    }
}

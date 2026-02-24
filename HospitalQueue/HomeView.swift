import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var showCategorySelection = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemTeal).opacity(0.06), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome, \(auth.userName)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Hospital Queue Management")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "person.crop.circle")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal)

                // Promo Banner
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue).opacity(0.15), Color(.systemTeal).opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))

                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(.systemBlue).opacity(0.2), lineWidth: 1)

                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quick Booking")
                                .font(.headline)
                            Text("Skip the line with priority slots")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Button(action: {}) {
                                Text("Learn More")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(6)
                            }
                        }
                        Spacer()
                        Image(systemName: "clock.badge.checkmark")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                .padding(.horizontal)

                // Main CTA Button
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    showCategorySelection = true
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                        Text("Get Service Token")
                            .font(.headline)
                        Text("Select your service type")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: Color(.systemBlue).opacity(0.25), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(.animated)
                .padding(.horizontal)

                // Quick Stats
                HStack(spacing: 12) {
                    QuickStatCard(title: "Avg Wait", value: "12 min", icon: "hourglass.bottomhalf.filled", color: Color(.systemOrange))
                    QuickStatCard(title: "People Ahead", value: "\(auth.peopleAhead)", icon: "person.2.fill", color: Color(.systemPurple))
                    QuickStatCard(title: "Active Counters", value: "5", icon: "building.2.fill", color: Color(.systemGreen))
                }
                .padding(.horizontal)

                Spacer()

                // Recent Tokens
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Tokens")
                        .font(.headline)
                        .padding(.horizontal)

                    if !auth.currentToken.isEmpty {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color(.systemTeal).opacity(0.1))
                                .frame(width: 36, height: 36)
                                .overlay(Image(systemName: "checkmark").foregroundColor(.green))

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Current Token")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(auth.currentToken)
                                    .font(.headline)
                            }

                            Spacer()

                            Button(action: {}) {
                                Text("View")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 10)
                                    .background(Color(.systemTeal))
                                    .cornerRadius(6)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)
                    } else {
                        Text("No recent tokens")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(.vertical)

            .navigationDestination(isPresented: $showCategorySelection) {
                CategorySelectionView()
                    .environmentObject(auth)
            }
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.08))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.2), lineWidth: 1))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView().environmentObject(AuthViewModel())
        }
    }
}

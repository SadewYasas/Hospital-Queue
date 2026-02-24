import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var selectedCategory: String?
    @State private var showNextScreen = false

    let categories = [
        ("OCD/Consultant", "stethoscope", Color(.systemTeal)),
        ("Emergency", "heart.fill", Color(.systemRed)),
        ("Admission", "building.2.fill", Color(.systemBlue)),
        ("Pharmacy", "pills.fill", Color(.systemGreen))
    ]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemTeal).opacity(0.06), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Service")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Choose the service you need")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 20)

                // Category Grid (2 columns)
                VStack(spacing: 16) {
                    ForEach(Array(categories.enumerated()), id: \.offset) { item in
                        let index = item.offset
                        let (title, icon, color) = item.element
                        if index % 2 == 0 {
                            HStack(spacing: 16) {
                                CategoryCard(
                                    title: title,
                                    icon: icon,
                                    color: color,
                                    isSelected: selectedCategory == title,
                                    action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedCategory = title
                                        }
                                    }
                                )

                                if index + 1 < categories.count {
                                    CategoryCard(
                                        title: categories[index + 1].0,
                                        icon: categories[index + 1].1,
                                        color: categories[index + 1].2,
                                        isSelected: selectedCategory == categories[index + 1].0,
                                        action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectedCategory = categories[index + 1].0
                                            }
                                        }
                                    )
                                } else {
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                Spacer()

                // Continue Button
                if selectedCategory != nil {
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        showNextScreen = true
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.animated)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }

            .navigationDestination(isPresented: $showNextScreen) {
                if selectedCategory == "OCD/Consultant" {
                    DoctorAppointmentView(category: selectedCategory ?? "")
                        .environmentObject(auth)
                } else {
                    // For other services, go directly to token generation
                    TokenGeneratedView()
                        .environmentObject(auth)
                        .onAppear {
                            auth.generateToken(for: selectedCategory ?? "")
                        }
                }
            }
        }
    }
}

struct CategoryCard: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)

                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color)
                    .shadow(color: color.opacity(0.3), radius: 12, x: 0, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategorySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CategorySelectionView()
                .environmentObject(AuthViewModel())
        }
    }
}

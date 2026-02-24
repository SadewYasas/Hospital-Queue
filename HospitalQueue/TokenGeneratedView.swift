import SwiftUI

struct TokenGeneratedView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showQR = false
    @State private var navigateToQueue = false
    @State private var animateCard = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color("AccentColor"))

                // Animated token card entrance
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(colors: [Color("AccentColor"), Color("AccentColor").opacity(0.9)], startPoint: .top, endPoint: .bottom))
                        .frame(height: 120)
                        .shadow(color: Color("AccentColor").opacity(0.12), radius: 10, x: 0, y: 6)

                    VStack(spacing: 6) {
                        Text("Token Number")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        Text(auth.currentToken)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .scaleEffect(animateCard ? 1 : 0.9)
                .opacity(animateCard ? 1 : 0)
                .rotation3DEffect(.degrees(animateCard ? 0 : 8), axis: (x: 1, y: 0, z: 0))
                .onAppear {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                        animateCard = true
                    }
                }
                Text("Your Token has been generated")
                    .font(.title3)
                    .fontWeight(.semibold)

                HStack(spacing: 12) {
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        showQR.toggle()
                    }) {
                        Text("Show QR")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.animated)

                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        navigateToQueue = true
                    }) {
                        Text("View Queue Status")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.animated)
                    .scaleEffect(navigateToQueue ? 1.02 : 1)
                    .animation(.easeInOut(duration: 0.25), value: navigateToQueue)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationDestination(isPresented: $navigateToQueue) {
                QueueStatusView()
                    .environmentObject(auth)
            }
            .sheet(isPresented: $showQR) {
                QRCodeView(code: auth.currentToken)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

struct TokenGeneratedView_Previews: PreviewProvider {
    static var previews: some View {
        TokenGeneratedView().environmentObject(AuthViewModel())
    }
}

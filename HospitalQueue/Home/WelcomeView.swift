//
//  WelcomeView.swift
//  HospitalQueue
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var goToHome = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Welcome \(appState.userName)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 48)
            
            medicalIllustration
                .padding(.vertical, 32)
            
            Spacer()
            
            PrimaryButton(title: "Lets Start") {
                appState.completeWelcome()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    private var medicalIllustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 120)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 280, height: 220)
            
            VStack(spacing: 16) {
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                Image(systemName: "pills.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white.opacity(0.9))
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

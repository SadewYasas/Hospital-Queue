//
//  RootView.swift
//  HospitalQueue
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if !appState.isLoggedIn {
                SignInView()
            } else if !appState.hasSeenWelcome {
                WelcomeView()
            } else {
                MainTabContainerView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.isLoggedIn)
        .animation(.easeInOut(duration: 0.25), value: appState.hasSeenWelcome)
    }
}

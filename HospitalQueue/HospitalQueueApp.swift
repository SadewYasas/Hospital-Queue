//
//  HospitalQueueApp.swift
//  HospitalQueue
//

import SwiftUI

@main
struct HospitalQueueApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}

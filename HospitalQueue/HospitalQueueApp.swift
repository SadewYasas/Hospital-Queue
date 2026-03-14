//
//  HospitalQueueApp.swift
//  HospitalQueue
//

import SwiftUI

@main
struct HospitalQueueApp: App {
    @StateObject private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(auth)
        }
    }
}

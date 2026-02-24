//
//  HospitalQueueApp.swift
//  HospitalQueue
//
//  Created by COBSCCOMP24.2P-075 on 2026-02-23.
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

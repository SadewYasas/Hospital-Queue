//
//  ContentView.swift
//  HospitalQueue
//
//  Created by COBSCCOMP24.2P-075 on 2026-02-23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        Group {
            if auth.isSignedIn {
                NavigationStack {
                    HomeView()
                        .environmentObject(auth)
                }
            } else {
                SignInView()
                    .environmentObject(auth)
            }
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}

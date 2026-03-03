//
//  ReviewView.swift
//  HospitalQueue
//

import SwiftUI

struct ReviewView: View {
    @State private var rating = 1
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 32) {
            Text("How was your experience ?")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 64)
            
            Text("Your feedback help us to improve")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            StarRatingView(rating: $rating)
                .padding(.vertical, 16)
            
            Spacer()
            
            NavigationLink(destination: HomeView()) {
                Text("Home")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.primaryGreen)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

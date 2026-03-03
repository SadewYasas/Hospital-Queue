//
//  StarRatingView.swift
//  HospitalQueue
//

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...maxRating, id: \.self) { index in
                Button(action: { rating = index }) {
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .font(.title)
                        .foregroundColor(index <= rating ? .yellow : Theme.borderGray)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

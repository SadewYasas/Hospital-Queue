//
//  NavigatorView.swift
//  HospitalQueue
//

import SwiftUI
import MapKit

struct NavigatorView: View {
    @StateObject private var tokenState = TokenState.shared
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    private let amenities: [(name: String, detail: String)] = [
        ("Cafeteria", "Breakfast/ lunch/ Dinner"),
        ("Pharmacy", "120m Left"),
        ("Rest rooms", "700m center"),
        ("Free Wifi", "Available all floors")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SG")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Rectangle()
                    .fill(Theme.borderGray)
                    .frame(width: 1, height: 20)
                Text(tokenState.currentToken)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Theme.borderGray, lineWidth: 1)
            )
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            Map(coordinateRegion: $region, annotationItems: [MapPin(id: "main", coordinate: region.center)]) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                }
            }
            .frame(height: 220)
            .cornerRadius(12)
            .padding(20)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(amenities, id: \.name) { amenity in
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(amenity.name == "Cafeteria" ? .orange : .primary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(amenity.name)
                                .font(.headline)
                            Text(amenity.detail)
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Navigator")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(Theme.primaryGreen)
                }
            }
        }
    }
}

struct MapPin: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
}

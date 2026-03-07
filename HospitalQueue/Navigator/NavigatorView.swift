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
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                Rectangle()
                    .fill(Color(UIColor.separator).opacity(0.5))
                    .frame(width: 1, height: 20)
                Text(tokenState.currentToken)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(12)
            .background(Color(UIColor.secondarySystemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color(UIColor.separator).opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
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
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(UIColor.separator).opacity(0.4), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
            .padding(20)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(amenities, id: \.name) { amenity in
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill((amenity.name == "Cafeteria") ? Color.orange.opacity(0.12) : Color.primary.opacity(0.08))
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle((amenity.name == "Cafeteria") ? .orange : Theme.primaryGreen)
                        }
                        .frame(width: 36, height: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(amenity.name)
                                .foregroundStyle(.primary)
                                .font(.subheadline.weight(.semibold))
                            Text(amenity.detail)
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color(UIColor.separator).opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 6)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            
            Spacer()
        }
        .background(
            LinearGradient(colors: [Color(UIColor.systemGroupedBackground), Color.white], startPoint: .top, endPoint: .bottom)
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: "map.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Theme.primaryGreen)
                    Text("Navigator")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Theme.primaryGreen)
                }
            }
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

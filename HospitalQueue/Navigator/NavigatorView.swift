
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
    
    private let amenities: [(name: String, detail: String, icon: String)] = [
        ("Cafeteria", "Breakfast • Lunch • Dinner", "fork.knife"),
        ("Pharmacy", "120 m to the left", "pills.fill"),
        ("Restrooms", "700 m ahead", "figure.walk"),
        ("Free Wi-Fi", "Available on all floors", "wifi")
    ]
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 24) {
                
                tokenCard
                
                mapSection
                
                amenitiesSection
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .background(
            LinearGradient(
                colors: [
                    Color(UIColor.systemGroupedBackground),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .principal) {
                
                HStack(spacing: 8) {
                    
                    Image(systemName: "map.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(AppTheme.primaryBlue)
                    
                    Text("Navigator")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(AppTheme.primaryBlue)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                NavigationLink(destination: ProfileView()) {
                    
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppTheme.primaryBlue)
                }
            }
        }
    }
}

extension NavigatorView {
    
    // MARK: Token Card
    
    private var tokenCard: some View {
        
        HStack(spacing: 12) {
            
            Text("SG")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            
            Divider()
                .frame(height: 18)
            
            Text(tokenState.currentToken)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(UIColor.separator).opacity(0.4), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.05),
            radius: 10,
            x: 0,
            y: 6
        )
    }
    
    // MARK: Map Section
    
    private var mapSection: some View {
        
        Map(
            coordinateRegion: $region,
            annotationItems: [
                MapPin(
                    id: "main",
                    coordinate: region.center
                )
            ]
        ) { item in
            
            MapAnnotation(coordinate: item.coordinate) {
                
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(AppTheme.primaryBlue)
            }
        }
        .frame(height: 240)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(UIColor.separator).opacity(0.35), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 16,
            x: 0,
            y: 8
        )
    }
    
    // MARK: Amenities Section
    
    private var amenitiesSection: some View {
        
        VStack(spacing: 12) {
            
            ForEach(amenities, id: \.name) { amenity in
                
                HStack(spacing: 14) {
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppTheme.primaryBlue.opacity(0.12))
                        
                        Image(systemName: amenity.icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.primaryBlue)
                    }
                    .frame(width: 36, height: 36)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        
                        Text(amenity.name)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.primary)
                        
                        Text(amenity.detail)
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(AppTheme.textSecondary.opacity(0.7))
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(UIColor.separator).opacity(0.35), lineWidth: 1)
                )
                .shadow(
                    color: Color.black.opacity(0.04),
                    radius: 10,
                    x: 0,
                    y: 6
                )
            }
        }
    }
}

// MARK: Map Pin Model

struct MapPin: Identifiable {
    
    let id: String
    let coordinate: CLLocationCoordinate2D
}


//
//  DoctorListView.swift
//  HospitalQueue
//

import SwiftUI

struct DoctorListView: View {
    @State private var searchText = ""
    @State private var selectedCategory: DoctorCategory? = nil
    
    private var filteredDoctors: [Doctor] {
        var list = DummyData.doctors
        if let cat = selectedCategory {
            list = list.filter { $0.category == cat.rawValue }
        }
        if !searchText.isEmpty {
            list = list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.affiliation.localizedCaseInsensitiveContains(searchText)
            }
        }
        return list
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                searchBar
                categorySection
                doctorListSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Doctor Appointment")
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
    
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Theme.textSecondary)
            TextField("Search Doctor", text: $searchText)
        }
        .padding(12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Theme.borderGray, lineWidth: 1)
        )
        .cornerRadius(10)
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Category to see available doctor")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(DoctorCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = selectedCategory == category ? nil : category
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: category.icon)
                                    .font(.title2)
                                    .foregroundColor(selectedCategory == category ? Theme.primaryGreen : Theme.textSecondary)
                                Text(category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                            .frame(width: 80)
                            .padding(.vertical, 12)
                            .background(selectedCategory == category ? Theme.primaryGreen.opacity(0.15) : Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedCategory == category ? Theme.primaryGreen : Theme.borderGray, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private var doctorListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selectedCategory.map { "Specialist \($0.rawValue)" } ?? "Popular Doctor")
                .font(.headline)
            ForEach(filteredDoctors) { doctor in
                NavigationLink(destination: DoctorDetailView(doctor: doctor)) {
                    DoctorCardView(doctor: doctor)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct DoctorCardView: View {
    let doctor: Doctor
    @State private var isFavorite = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: doctor.imageName)
                .font(.system(size: 60))
                .foregroundColor(Theme.primaryGreen)
                .frame(width: 80, height: 80)
                .background(Theme.primaryGreen.opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(doctor.name)
                        .font(.headline)
                    Spacer()
                    Button(action: { isFavorite.toggle() }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : Theme.textSecondary)
                    }
                    .buttonStyle(.plain)
                }
                Text(doctor.affiliation)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Patients")
                            .font(.caption2)
                            .foregroundColor(Theme.textSecondary)
                        Text(doctor.patients)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Experience")
                            .font(.caption2)
                            .foregroundColor(Theme.textSecondary)
                        Text(doctor.experience)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Rating")
                            .font(.caption2)
                            .foregroundColor(Theme.textSecondary)
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                            Text("(\(String(format: "%.1f", doctor.rating)))")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
}

//
//  DummyData.swift
//  HospitalQueue
//

import SwiftUI

struct Doctor: Identifiable {
    let id = UUID()
    let name: String
    let affiliation: String
    let patients: String
    let experience: String
    let rating: Double
    let category: String
    let details: String
    let imageName: String
}

enum DoctorCategory: String, CaseIterable {
    case cardiologist = "Cardiologist"
    case neurologist = "Neurologist"
    case childSpecialist = "Child Specialist"
    case dentist = "Dentist"
    
    var icon: String {
        switch self {
        case .cardiologist: return "heart.fill"
        case .neurologist: return "brain.head.profile"
        case .childSpecialist: return "figure.and.child.holdinghands"
        case .dentist: return "mouth"
        }
    }
}

enum DummyData {
    static let doctors: [Doctor] = [
        Doctor(
            name: "Dr. Bandula Samarasinghe",
            affiliation: "KDU Medical University",
            patients: "5.5K",
            experience: "15 Years",
            rating: 4.5,
            category: "Cardiologist",
            details: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
            imageName: "person.circle.fill"
        ),
        Doctor(
            name: "Dr. Bandula Samarasinghe",
            affiliation: "KDU Medical University",
            patients: "5.0K",
            experience: "10 Years",
            rating: 4.5,
            category: "Neurologist",
            details: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
            imageName: "person.circle.fill"
        ),
        Doctor(
            name: "Dr. Jane Smith",
            affiliation: "General Hospital",
            patients: "3.2K",
            experience: "8 Years",
            rating: 4.8,
            category: "Child Specialist",
            details: "Specialized in pediatric care.",
            imageName: "person.circle.fill"
        ),
        Doctor(
            name: "Dr. John Doe",
            affiliation: "Dental Institute",
            patients: "2.1K",
            experience: "12 Years",
            rating: 4.6,
            category: "Dentist",
            details: "General and cosmetic dentistry.",
            imageName: "person.circle.fill"
        )
    ]
    
    static let timeSlots = ["8:00 AM", "9:00 AM", "10:00 AM", "2:00 PM", "3:00 PM"]
    static let scheduleDates = ["April, 6", "April, 7", "April, 8", "April, 9", "April, 10"]
}

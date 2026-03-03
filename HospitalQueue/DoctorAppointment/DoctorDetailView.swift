//
//  DoctorDetailView.swift
//  HospitalQueue
//

import SwiftUI

struct DoctorDetailView: View {
    let doctor: Doctor
    @State private var selectedTime = "8:00 AM"
    @State private var selectedDate = "April, 6"
    @State private var showBookingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                doctorHeader
                statsRow
                detailsSection
                workingHourSection
                scheduleSection
                PrimaryButton(title: "Book Appointment") {
                    showBookingConfirmation = true
                }
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
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
        .alert("Booking Confirmed", isPresented: $showBookingConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your appointment with \(doctor.name) on \(selectedDate) at \(selectedTime) has been booked.")
        }
    }
    
    private var doctorHeader: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: doctor.imageName)
                .font(.system(size: 70))
                .foregroundColor(Theme.primaryGreen)
                .frame(width: 90, height: 90)
                .background(Theme.primaryGreen.opacity(0.15))
                .cornerRadius(12)
            VStack(alignment: .leading, spacing: 6) {
                Text(doctor.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(doctor.affiliation)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "phone.fill")
                            .font(.title3)
                            .foregroundColor(Theme.primaryGreen)
                    }
                    Button(action: {}) {
                        Image(systemName: "video.fill")
                            .font(.title3)
                            .foregroundColor(Theme.primaryGreen)
                    }
                    Button(action: {}) {
                        Image(systemName: "message.fill")
                            .font(.title3)
                            .foregroundColor(Theme.primaryGreen)
                    }
                }
                .padding(.top, 4)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var statsRow: some View {
        HStack(spacing: 0) {
            statItem(title: "Patients", value: doctor.patients)
            statItem(title: "Experience", value: doctor.experience)
            statItem(title: "Reviews", value: "4.2K")
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private func statItem(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Details")
                .font(.headline)
            Text(doctor.details)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var workingHourSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Working Hour")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(DummyData.timeSlots, id: \.self) { slot in
                        Button(action: { selectedTime = slot }) {
                            Text(slot)
                                .font(.subheadline)
                                .foregroundColor(selectedTime == slot ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(selectedTime == slot ? Theme.primaryGreen : Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTime == slot ? Color.clear : Theme.borderGray, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedule")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(DummyData.scheduleDates, id: \.self) { date in
                        Button(action: { selectedDate = date }) {
                            Text(date)
                                .font(.subheadline)
                                .foregroundColor(selectedDate == date ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(selectedDate == date ? Theme.primaryGreen : Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedDate == date ? Color.clear : Theme.borderGray, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
}

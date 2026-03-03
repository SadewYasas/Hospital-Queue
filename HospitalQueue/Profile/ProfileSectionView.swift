//
//  ProfileSectionView.swift
//  HospitalQueue
//

import SwiftUI

struct FamilyMember: Identifiable {
    let id = UUID()
    var name: String
    var role: String
}

struct ProfileSectionView: View {
    @State private var members: [FamilyMember] = [
        FamilyMember(name: "Sadew Yasas", role: "Primary User"),
        FamilyMember(name: "Ravindu Thennakoon", role: "Secondary User")
    ]
    @State private var showAddMember = false
    
    var body: some View {
        List {
            Section {
                ForEach(members) { member in
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(Theme.primaryGreen)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(member.name)
                                .font(.headline)
                            Text(member.role)
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section {
                Button(action: { showAddMember = true }) {
                    HStack {
                        Spacer()
                        Text("Add Family Member")
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.primaryGreen)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                }
                .listRowBackground(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Theme.primaryGreen, lineWidth: 2)
                )
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Profile Section")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddMember) {
            AddFamilyMemberView(members: $members)
        }
    }
}

struct AddFamilyMemberView: View {
    @Binding var members: [FamilyMember]
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var role = "Secondary User"
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Full Name", text: $name)
                Picker("Role", selection: $role) {
                    Text("Primary User").tag("Primary User")
                    Text("Secondary User").tag("Secondary User")
                }
            }
            .navigationTitle("Add Family Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        members.append(FamilyMember(name: name.isEmpty ? "New Member" : name, role: role))
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

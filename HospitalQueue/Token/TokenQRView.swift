//
//  TokenQRView.swift
//  HospitalQueue
//

import SwiftUI
import CoreImage
import UIKit

struct TokenQRView: View {
    let serviceType: WalkInService
    @StateObject private var tokenState = TokenState.shared
    @State private var showQueueStatus = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(Theme.primaryGreen)
                .padding(.top, 24)
            
            Text("Your token has been\ngenerated")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            QRCodeView(string: tokenState.currentToken)
                .frame(width: 200, height: 200)
                .padding(.vertical, 16)
            
            Text("Scan at the counter for verification")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            PrimaryButton(title: "Hide QR") { }
            .padding(.horizontal, 24)
            
            PrimaryButton(title: "View Queue Status") {
                showQueueStatus = true
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showQueueStatus) {
            QueueStatusView()
        }
    }
}

struct QRCodeView: View {
    let string: String
    
    var body: some View {
        if let image = generateQRCode(from: string) {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.borderGray)
                .overlay(Text("QR").foregroundColor(.secondary))
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        guard let output = filter.outputImage else { return nil }
        let scale = 200 / output.extent.size.width
        let scaled = output.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

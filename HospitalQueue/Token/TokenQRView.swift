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
        
        VStack(spacing: 28) {
            
            header
            
            tokenCard
            
            qrCard
            
            actionButtons
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 30)
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
        .navigationDestination(isPresented: $showQueueStatus) {
            QueueStatusView()
        }
    }
}

extension TokenQRView {
    
    private var header: some View {
        VStack(spacing: 12) {
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundStyle(Theme.primaryGreen)
                .symbolRenderingMode(.hierarchical)
            
            Text("Token Generated")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Text("Please scan this QR code at the counter")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    private var tokenCard: some View {
        
        VStack(spacing: 6) {
            
            Text("Your Token")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(tokenState.currentToken)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primaryGreen)
            
            Text(serviceType.rawValue)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
        )
    }
    
    private var qrCard: some View {
        
        VStack(spacing: 18) {
            
            QRCodeView(string: tokenState.currentToken)
                .frame(width: 200, height: 200)
            
            Text("Scan for verification")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(26)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
        )
    }
    
    private var actionButtons: some View {
        
        VStack(spacing: 14) {
            
            PrimaryButton(title: "View Queue Status") {
                showQueueStatus = true
            }
            
            Button {
                
            } label: {
                Text("Hide QR")
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.gray.opacity(0.12))
                    )
            }
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
                .overlay(
                    Text("QR")
                        .foregroundColor(.secondary)
                )
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        
        let data = Data(string.utf8)
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let output = filter.outputImage else { return nil }
        
        let scale = 200 / output.extent.size.width
        
        let scaled = output.transformed(
            by: CGAffineTransform(scaleX: scale, y: scale)
        )
        
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(
            scaled,
            from: scaled.extent
        ) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}

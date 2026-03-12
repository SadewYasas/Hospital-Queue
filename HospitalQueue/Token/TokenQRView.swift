
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
        
        ScrollView {
            
            VStack(spacing: 26) {
                
                header
                
                tokenCard
                
                qrCard
                
                actionButtons
                
            }
            .padding(.horizontal, 24)
            .padding(.top, 30)
            .padding(.bottom, 40)
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
        .navigationDestination(isPresented: $showQueueStatus) {
            QueueStatusView()
        }
    }
}

extension TokenQRView {
    
    // MARK: Header
    
    private var header: some View {
        
        VStack(spacing: 14) {
            
            ZStack {
                
                Circle()
                    .fill(AppTheme.primaryBlue.opacity(0.12))
                    .frame(width: 74, height: 74)
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(AppTheme.primaryBlue)
            }
            
            Text("Token Generated")
                .font(.system(size: 24, weight: .bold))
            
            Text("Show this QR code at the service counter for verification.")
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: Token Card
    
    private var tokenCard: some View {
        
        VStack(spacing: 10) {
            
            Text("Token Number")
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
            
            Text(tokenState.currentToken)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.primaryBlue)
            
            HStack(spacing: 6) {
                
                Image(systemName: "stethoscope")
                    .font(.caption)
                
                Text(serviceType.rawValue)
                    .font(.subheadline)
            }
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(UIColor.separator).opacity(0.35), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.06),
            radius: 12,
            x: 0,
            y: 6
        )
    }
    
    // MARK: QR Card
    
    private var qrCard: some View {
        
        VStack(spacing: 18) {
            
            QRCodeView(string: tokenState.currentToken)
                .frame(width: 210, height: 210)
            
            HStack(spacing: 6) {
                
                Image(systemName: "qrcode.viewfinder")
                    .font(.caption)
                
                Text("Scan for verification")
                    .font(.caption)
            }
            .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(UIColor.separator).opacity(0.35), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 16,
            x: 0,
            y: 8
        )
    }
    
    // MARK: Buttons
    
    private var actionButtons: some View {
        
        VStack(spacing: 14) {
            
            Button {
                showQueueStatus = true
            } label: {
                
                HStack {
                    
                    Image(systemName: "list.number")
                    
                    Text("View Queue Status")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppTheme.primaryBlue)
                )
            }
            
            Button {
                
            } label: {
                
                HStack {
                    
                    Image(systemName: "eye.slash")
                    
                    Text("Hide QR Code")
                        .fontWeight(.semibold)
                }
                .foregroundColor(AppTheme.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(UIColor.secondarySystemBackground))
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
                .fill(AppTheme.borderGray)
                .overlay(
                    Image(systemName: "qrcode")
                        .font(.title2)
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


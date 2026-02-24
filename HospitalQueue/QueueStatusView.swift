import SwiftUI
import MapKit

struct QueueStatusView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var progress: CGFloat = 0
    @State private var animateCheckmark = false
    @State private var showQRCodeSheet = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 31.5204, longitude: 74.3587),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemTeal).opacity(0.06), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Navigation Bar
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Queue Status")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Real-time updates")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.white)
                .border(Color.gray.opacity(0.1), width: 1)

                // Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Status Badge
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                                .scaleEffect(animateCheckmark ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6).repeatCount(2), value: animateCheckmark)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        animateCheckmark = true
                                    }
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Token Generated Successfully")
                                    .font(.headline)
                                Text("You're in the queue")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                        .padding(12)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top, 12)

                        // Token Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color(.systemTeal), Color(.systemTeal).opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(color: Color(.systemTeal).opacity(0.25), radius: 16, x: 0, y: 8)

                            VStack(spacing: 16) {
                                VStack(spacing: 8) {
                                    Text("Token Number")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.9))
                                    Text(auth.currentToken)
                                        .font(.system(size: 56, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                }

                                VStack(spacing: 12) {
                                    HStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("People Ahead")
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.8))
                                            HStack(spacing: 4) {
                                                Image(systemName: "person.2.fill")
                                                Text("\(auth.peopleAhead)")
                                                    .fontWeight(.semibold)
                                            }
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        }

                                        Divider()
                                            .frame(height: 30)
                                            .opacity(0.3)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Est. Wait Time")
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.8))
                                            HStack(spacing: 4) {
                                                Image(systemName: "clock.fill")
                                                Text("\(auth.estimatedWaitMinutes) mins")
                                                    .fontWeight(.semibold)
                                            }
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        }

                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(24)
                        }
                        .frame(height: 220)
                        .padding(.horizontal)

                        // Progress Bar
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Queue Progress")
                                    .font(.headline)
                                Spacer()
                                Text("\(min(100, Int((1 - CGFloat(auth.peopleAhead) / 15.0) * 100)))%")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }

                            GeometryReader { geo in
                                let fraction = auth.peopleAhead > 0 ? max(0, 1 - (CGFloat(auth.peopleAhead) / 15.0)) : 1.0
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.1))
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                                        .frame(width: max(8, geo.size.width * progress))
                                        .animation(.easeOut(duration: 0.8), value: progress)
                                }
                                .frame(height: 12)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        progress = fraction
                                    }
                                }
                            }
                            .frame(height: 12)
                        }
                        .padding(.horizontal)

                        // Action Buttons
                        HStack(spacing: 12) {
                            Button(action: { showQRCodeSheet = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "qrcode")
                                    Text("Show QR")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray6))
                                .foregroundColor(.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .buttonStyle(.animated)

                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "bell.fill")
                                    Text("Notify Me")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .buttonStyle(.animated)
                        }
                        .padding(.horizontal)

                        // Live Counters
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Live Counter Status")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(auth.counters.indices, id: \.self) { i in
                                HStack(spacing: 12) {
                                    Image(systemName: "building.2.fill")
                                        .font(.title3)
                                        .foregroundColor(Color(.systemTeal))
                                        .frame(width: 36, height: 36)
                                        .background(Color(.systemTeal).opacity(0.1))
                                        .cornerRadius(8)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Counter \(i+1)")
                                            .fontWeight(.semibold)
                                        Text(auth.counters[i])
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("Open")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.green)
                                        Image(systemName: "circle.fill")
                                            .font(.caption2)
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                            }
                            .padding(.horizontal)
                        }

                        // Map Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Hospital Location")
                                .font(.headline)
                                .padding(.horizontal)

                            Map(position: .constant(.region(region)))
                                .frame(height: 220)
                                .cornerRadius(14)
                                .padding(.horizontal)
                                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                        }

                        // QR Code Section (preview)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your QR Code")
                                .font(.headline)
                                .padding(.horizontal)

                            ZStack {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)

                                if let img = generateQRCode(from: auth.currentToken) {
                                    VStack(spacing: 12) {
                                        Image(uiImage: img)
                                            .interpolation(.none)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 140, height: 140)

                                        Text("Scan at counter for verification")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                }
                            }
                            .frame(height: 200)
                            .padding(.horizontal)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.vertical, 20)
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showQRCodeSheet) {
            QRCodeView(code: auth.currentToken)
        }
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10)), from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}

struct QueueStatusView_Previews: PreviewProvider {
    static var previews: some View {
        QueueStatusView().environmentObject(AuthViewModel())
    }
}

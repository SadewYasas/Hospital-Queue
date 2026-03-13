import SwiftUI
import MapKit

struct QueueStatusView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) var dismiss
    /// When non-nil (e.g. opened from dashboard), Close goes to root. When nil (pushed from token flow), Close pops.
    var path: Binding<[Route]>?
    /// When true, show "Token Generated Successfully" badge. When false (e.g. viewing from dashboard), show simpler status.
    var isNewlyCreated: Bool = false
    /// Queue progress 0...1, derived from peopleAhead so bar and percentage stay in sync.
    private var queueProgressFraction: CGFloat {
        auth.peopleAhead > 0 ? max(0, 1 - (CGFloat(auth.peopleAhead) / 15.0)) : 1.0
    }
    @State private var animateCheckmark = false
    @State private var notificationsEnabled = false
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
                    Button(action: {
                        if let path = path {
                            path.wrappedValue.removeAll()
                        } else {
                            dismiss()
                        }
                    }) {
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
                        // Status Badge (only show "Token Generated Successfully" when newly created)
                        if isNewlyCreated {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                    .scaleEffect(animateCheckmark ? 1.0 : 0.92)
                                    .opacity(animateCheckmark ? 1 : 0)
                                    .animation(Animation.iosEntrance, value: animateCheckmark)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                            withAnimation(Animation.iosEntrance) {
                                                animateCheckmark = true
                                            }
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
                        } else {
                            HStack(spacing: 8) {
                                Image(systemName: "clock.badge.checkmark")
                                    .font(.title2)
                                    .foregroundColor(Color(.systemTeal))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("You're in the queue")
                                        .font(.headline)
                                    Text("Real-time updates")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(.systemTeal).opacity(0.08))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top, 12)
                        }

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

                        // Progress Bar (use same formula as percentage so they stay in sync)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Queue Progress")
                                    .font(.headline)
                                Spacer()
                                Text("\(min(100, Int(queueProgressFraction * 100)))%")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.1))
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]), startPoint: .leading, endPoint: .trailing))
                                        .frame(width: max(8, geo.size.width * queueProgressFraction))
                                        .animation(Animation.iosEaseOut, value: queueProgressFraction)
                                }
                                .frame(height: 12)
                            }
                            .frame(height: 12)
                        }
                        .padding(.horizontal)

                        // QR Code (always visible, prominent)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your QR Code")
                                .font(.headline)
                                .padding(.horizontal)

                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 6)

                                if let img = generateQRCode(from: "HOSPITAL-QUEUE-TOKEN") {
                                    VStack(spacing: 12) {
                                        Image(uiImage: img)
                                            .interpolation(.none)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 220, height: 220)

                                        Text("Scan at counter for verification")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(24)
                                } else {
                                    VStack(spacing: 12) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.systemGray5))
                                            .frame(width: 220, height: 220)
                                            .overlay(
                                                Image(systemName: "qrcode")
                                                    .font(.system(size: 80))
                                                    .foregroundColor(.white)
                                            )
                                        Text("Scan at counter for verification")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(24)
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Notify when turn is near (toggle)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Queue notifications")
                                        .font(.headline)
                                    Text("Alert me when my turn is near")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Toggle("", isOn: $notificationsEnabled)
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.15), lineWidth: 1))
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

                        Spacer(minLength: 40)
                    }
                    .padding(.vertical, 20)
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationBarBackButtonHidden(isNewlyCreated && path != nil)
        .toolbar {
            if isNewlyCreated, let path = path {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { path.wrappedValue.removeAll() }) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        guard let outputImage = filter.outputImage else { return nil }
        let scale = 220 / max(outputImage.extent.width, outputImage.extent.height)
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        guard let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        return UIImage(cgImage: cgimg)
    }
}

struct QueueStatusView_Previews: PreviewProvider {
    static var previews: some View {
        QueueStatusView(path: nil).environmentObject(AuthViewModel())
    }
}

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let code: String
    @Environment(\.dismiss) private var dismiss
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        VStack(spacing: 20) {
            Text("Scan at the counter for verification")
                .font(.headline)

            qrImage
                .frame(width: 220, height: 220)
                .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 8)
                .transition(.scale.combined(with: .opacity))
                .animation(Animation.iosEntrance, value: code)

            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                dismiss()
            }) {
                Text("Hide QR")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private var qrImage: some View {
        if let img = generateQRCode(from: code) {
            Image(uiImage: img)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
        } else {
            placeholderQR
        }
    }

    private var placeholderQR: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
            Image(systemName: "qrcode")
                .font(.system(size: 80))
                .foregroundColor(.white)
        }
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        filter.message = data
        filter.correctionLevel = "M"
        guard let outputImage = filter.outputImage else { return nil }
        let scale = 220 / max(outputImage.extent.width, outputImage.extent.height)
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        guard let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        return UIImage(cgImage: cgimg)
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView(code: "A-075")
    }
}

import SwiftUI

struct ServiceRow: View {
    let service: String
    var action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: {
            pressed = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                pressed = false
            }
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(service)
                        .fontWeight(.semibold)
                    Text("Tap to get a token")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 4)
            .scaleEffect(pressed ? 0.98 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: pressed)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct ServiceRow_Previews: PreviewProvider {
    static var previews: some View {
        ServiceRow(service: "Emergency") {}
    }
}

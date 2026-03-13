import SwiftUI

struct AnimatedButtonStyle: ButtonStyle {
    /// Slight scale on press (iOS-style ~0.97); avoid aggressive squash.
    var scaleAmount: CGFloat = 0.97
    var pressedOpacity: Double = 0.96

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .opacity(configuration.isPressed ? pressedOpacity : 1)
            .animation(Animation.iosInteractive, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == AnimatedButtonStyle {
    static var animated: AnimatedButtonStyle { .init() }
}

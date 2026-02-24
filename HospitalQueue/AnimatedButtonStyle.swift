import SwiftUI

struct AnimatedButtonStyle: ButtonStyle {
    var scaleAmount: CGFloat = 0.96
    var pressedOpacity: Double = 0.95

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .opacity(configuration.isPressed ? pressedOpacity : 1)
            .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.7, blendDuration: 0.2), value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.01 : 0)
    }
}

extension ButtonStyle where Self == AnimatedButtonStyle {
    static var animated: AnimatedButtonStyle { .init() }
}

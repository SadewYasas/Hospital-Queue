import SwiftUI

/// iOS-standard animation constants for consistent, native-feeling transitions (HIG-aligned).
extension Animation {
    /// Standard spring: smooth, minimal bounce. Use for view transitions and content appearance.
    /// Response ~0.5s, dampingFraction 0.82 (close to system default).
    static let iosStandard = Animation.spring(response: 0.5, dampingFraction: 0.82)

    /// Snappy spring: quick response, light bounce. Use for selection state (cards, chips).
    static let iosSnappy = Animation.spring(response: 0.35, dampingFraction: 0.75)

    /// Interactive spring: for button press feedback (scale/opacity). Kept short and responsive.
    static let iosInteractive = Animation.interactiveSpring(response: 0.25, dampingFraction: 0.75, blendDuration: 0.2)

    /// Gentle ease-out for progress bars and linear-style UI.
    static let iosEaseOut = Animation.easeOut(duration: 0.35)

    /// Slightly longer ease for entrance of important content (e.g. token card).
    static let iosEntrance = Animation.spring(response: 0.55, dampingFraction: 0.8)
}

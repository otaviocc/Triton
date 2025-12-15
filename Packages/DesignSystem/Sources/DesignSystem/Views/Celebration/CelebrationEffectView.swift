import SwiftUI

/// A SwiftUI view that displays an animated celebration effect with particles.
///
/// This view creates a visual celebration by animating 20 particles across the screen.
/// Each particle is a randomly selected SF Symbol (heart, star, sparkles, or party popper)
/// with a random color, creating a festive and dynamic effect.
///
/// The particles animate outward from the center of the view with varying velocities,
/// scales, rotations, and fade out over time. The view is non-interactive and designed
/// to overlay other content as a temporary visual feedback.
///
/// Use this view in a `ZStack` to layer the celebration effect over your main content:
///
/// ```swift
/// ZStack {
///     // Your main content here
///     VStack { ... }
///
///     if showCelebration {
///         CelebrationEffectView()
///     }
/// }
/// ```
public struct CelebrationEffectView: View {

    // MARK: - Properties

    private let symbols = ["heart.fill", "star.fill", "sparkles", "party.popper.fill"]
    private let colors: [Color] = [.red, .pink, .orange, .yellow, .purple]

    // MARK: - Public

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<20, id: \.self) { index in
                    ParticleView(
                        symbol: symbols.randomElement() ?? "heart.fill",
                        color: colors.randomElement() ?? .red,
                        geometry: geometry
                    )
                    .id(index)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

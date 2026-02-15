// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

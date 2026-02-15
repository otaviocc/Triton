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

public extension AsyncImage {

    /// Styles an AsyncImage as a large rounded icon with consistent dimensions.
    ///
    /// This modifier formats the AsyncImage to display as a circular icon by setting it to a
    /// 64x64 point size and applying a corner radius of 32 points (making it perfectly circular).
    /// This creates a consistent appearance for app icons or profile images throughout the application.
    ///
    /// - Returns: A view styled as a circular icon with standard large dimensions.
    ///
    /// ## Example
    /// ```swift
    /// AsyncImage(url: URL(string: "https://example.com/icon.png"))
    ///     .roundedIcon()
    /// ```
    func roundedIcon() -> some View {
        modifier(RoundIconModifier())
    }
}

// MARK: - Private

private struct RoundIconModifier: ViewModifier {

    func body(
        content: Content
    ) -> some View {
        content
            .frame(width: 64, height: 64)
            .clipShape(.rect(cornerRadius: 32))
    }
}

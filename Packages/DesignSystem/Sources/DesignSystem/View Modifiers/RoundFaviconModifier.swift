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

    /// Styles an AsyncImage as a rounded favicon with consistent dimensions.
    ///
    /// This modifier formats the AsyncImage to display as a favicon by setting it to a
    /// 16x16 point size and applying rounded corners with a 4-point radius. This creates
    /// a consistent appearance for website favicons throughout the application.
    ///
    /// - Returns: A view styled as a rounded favicon with standard dimensions.
    ///
    /// ## Example
    /// ```swift
    /// AsyncImage(url: URL(string: "https://example.com/favicon.ico"))
    ///     .roundedFavicon()
    /// ```
    func roundedFavicon() -> some View {
        modifier(RoundFaviconModifier())
    }
}

// MARK: - Private

private struct RoundFaviconModifier: ViewModifier {

    func body(
        content: Content
    ) -> some View {
        content
            .frame(width: 16, height: 16)
            .clipShape(.rect(cornerRadius: 4))
    }
}

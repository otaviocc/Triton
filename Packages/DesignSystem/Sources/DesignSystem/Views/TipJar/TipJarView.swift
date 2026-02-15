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

import FoundationExtensions
import SwiftUI

/// A SwiftUI view that displays the Tip Jar interface for supporting the developer.
///
/// This view presents a friendly, informal interface encouraging users to support
/// the application development through Ko-fi donations. It features a coffee cup
/// icon, casual messaging, and a prominent link to the Ko-fi donation page.
///
/// The view is designed to be non-intrusive and playful, fitting the overall
/// tone of the application while providing users an easy way to show appreciation.
public struct TipJarView: View {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("Enjoying the app?")
                .font(.headline)

            Text("Buy me a coffee and keep the pixels flowing ☕️")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Link(destination: .tipJarURL) {
                HStack {
                    Image(systemName: "heart.fill")
                    Text("Support on Ko-fi")
                }
                .frame(maxWidth: 200)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(.full)
        .padding()
    }
}

// MARK: - Preview

#Preview {
    TipJarView()
}

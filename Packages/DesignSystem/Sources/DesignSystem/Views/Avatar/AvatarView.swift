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

/// A view that displays a user's avatar image loaded asynchronously from a URL based on their address.
public struct AvatarView: View {

    // MARK: - Properties

    private let address: String

    // MARK: - Lifecycle

    /// Initializes an avatar view for the specified user address.
    ///
    /// - Parameter address: The user's address identifier used to generate the avatar URL.
    public init(
        address: String
    ) {
        self.address = address
    }

    // MARK: - Public

    public var body: some View {
        let url = URL(avatarFor: address)

        AsyncImage(
            url: url,
            content: { image in
                image
                    .resizable()
                    .scaledToFill()
            },
            placeholder: {
                Color.omgBackground.opacity(0.1)
            }
        )
        .roundedIcon()
    }
}

// MARK: - Preview

#Preview {
    AvatarView(
        address: "otaviocc"
    )
}

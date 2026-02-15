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

/// A text editor with placeholder text support.
///
/// `PlaceholderTextEditor` extends the standard `TextEditor` by adding placeholder text
/// that appears when the editor is empty. The placeholder text is displayed in a secondary
/// color and automatically disappears when the user begins typing.
public struct PlaceholderTextEditor: View {

    // MARK: - Properties

    private let placeholder: String
    private var text: Binding<String>
    private var help: String

    // MARK: - Lifecycle

    /// Creates a text editor with placeholder support.
    ///
    /// - Parameters:
    ///   - placeholder: The text to display when the editor is empty.
    ///   - text: A binding to the text being edited.
    ///   - help: The help text displayed on hover.
    public init(
        placeholder: String,
        text: Binding<String>,
        help: String
    ) {
        self.placeholder = placeholder
        self.text = text
        self.help = help
    }

    // MARK: - Public

    public var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: text)
                .autocorrectionDisabled(false)
                .font(.body.monospaced())
                .textEditorCard()
                .help(help)

            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(.secondary)
                    .font(.body.monospaced())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 13)
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - Preview

#Preview("Without Content") {
    PlaceholderTextEditor(
        placeholder: "Caption",
        text: .constant(""),
        help: "Add a caption for your image"
    )
    .frame(width: 400)
}

#Preview("With Content") {
    PlaceholderTextEditor(
        placeholder: "Alt text",
        text: .constant("Photo of a beautiful beach on a sunny day"),
        help: "Add descriptive alt text for accessibility"
    )
    .frame(width: 400)
}

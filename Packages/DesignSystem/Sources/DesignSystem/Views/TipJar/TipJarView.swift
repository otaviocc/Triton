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

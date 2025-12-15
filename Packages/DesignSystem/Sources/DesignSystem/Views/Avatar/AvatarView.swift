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

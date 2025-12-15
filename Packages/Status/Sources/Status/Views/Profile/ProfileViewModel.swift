import Observation

@MainActor
@Observable
final class ProfileViewModel {

    // MARK: - Properties

    let address: String

    // MARK: - Computed Properties

    var formattedAddress: String {
        "@\(address)"
    }

    // MARK: - Lifecycle

    init(
        address: String
    ) {
        self.address = address
    }
}

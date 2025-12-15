import SwiftUI

struct AddressView: View {

    // MARK: - Properties

    @State private var isPopoverPresented = false
    @Environment(\.viewModelFactory) private var viewModelFactory

    private let address: String
    private var formattedAddress: String {
        "@\(address)"
    }

    // MARK: - Lifecycle

    init(
        address: String
    ) {
        self.address = address
    }

    // MARK: - Public

    var body: some View {
        Text(formattedAddress)
            .font(.headline)
            .foregroundColor(.black)
            .onTapGesture {
                isPopoverPresented = true
            }
            .popover(
                isPresented: $isPopoverPresented,
                arrowEdge: .bottom
            ) {
                ProfileView(
                    viewModel: viewModelFactory.makeProfileViewModel(
                        address: address
                    )
                )
            }
    }
}

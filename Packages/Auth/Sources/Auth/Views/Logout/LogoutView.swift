import DesignSystem
import SwiftUI

struct LogoutView: View {

    // MARK: - Properties

    @State private var viewModel: LogoutViewModel

    // MARK: - Lifecycle

    init(
        viewModel: LogoutViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack {
            Image(systemName: "heart.circle")
                .font(.system(size: 56))
                .frame(width: 60, height: 60)

            Text("I'm sorry to see you go :-(")
                .font(.body)

            Button {
                viewModel.logout()
            } label: {
                Text("Log out")
            }
        }
        .frame(.full)
        .padding()
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        LogoutView(
            viewModel: LogoutViewModelMother.makeLogoutViewModel()
        )
        .frame(width: 300, height: 300)
    }

#endif

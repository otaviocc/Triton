import DesignSystem
import SwiftUI

struct LoginView: View {

    // MARK: - Properties

    @State private var viewModel: LoginViewModel
    @Environment(\.openURL) private var openURL

    // MARK: - Lifecycle

    init(
        viewModel: LoginViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 56))
                .frame(width: 60, height: 60)

            Text("Hi there! Please log in to continue using the app.")
                .font(.body)

            Button {
                openURL(viewModel.codeRequestURL)
            } label: {
                Text("Log in")
            }
        }
        .frame(.full)
        .padding()
        .onOpenURL { url in
            viewModel.handleDeeplinkURL(url)
        }
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        LoginView(
            viewModel: LoginViewModelMother.makeLoginViewModel()
        )
        .frame(width: 300, height: 300)
    }

#endif

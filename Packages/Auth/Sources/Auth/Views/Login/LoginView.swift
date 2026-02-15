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

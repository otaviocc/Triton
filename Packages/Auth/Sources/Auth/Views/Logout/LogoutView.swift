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

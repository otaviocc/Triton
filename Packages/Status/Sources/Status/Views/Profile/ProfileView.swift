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
import FoundationExtensions
import SwiftUI

struct ProfileView: View {

    // MARK: - Properties

    @State private var viewModel: ProfileViewModel
    @Environment(\.openURL) private var openURL

    // MARK: - Lifecycle

    init(
        viewModel: ProfileViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack(alignment: .center) {
            AvatarView(address: viewModel.address)

            VStack(alignment: .leading) {
                Text(viewModel.formattedAddress)
                    .font(.headline)

                HStack(alignment: .center, spacing: 8) {
                    makeWebpageView()
                    makeNowPageView()
                    makeWeblogView()
                }
                .buttonStyle(.borderless)
                .foregroundStyle(Color.accentColor)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Private

    @ViewBuilder
    private func makeWebpageView() -> some View {
        let url = URL(webpageFor: viewModel.address)

        Button {
            openURL(url)
        } label: {
            Label("Webpage", systemImage: "safari")
        }
        .help("Open webpage in browser")
        .labelStyle(.distanced)
    }

    @ViewBuilder
    private func makeNowPageView() -> some View {
        let url = URL(nowPageFor: viewModel.address)

        Button {
            openURL(url)
        } label: {
            Label("Now Page", systemImage: "clock")
        }
        .help("Open now page in browser")
        .labelStyle(.distanced)
    }

    @ViewBuilder
    private func makeWeblogView() -> some View {
        let url = URL(weblogFor: viewModel.address)

        Button {
            openURL(url)
        } label: {
            Label("Weblog", systemImage: "text.below.photo")
        }
        .help("Open weblog in browser")
        .labelStyle(.distanced)
    }
}

// MARK: - Preview

#Preview {
    ProfileView(
        viewModel: .init(
            address: "otaviocc"
        )
    )
    .frame(width: 400)
}

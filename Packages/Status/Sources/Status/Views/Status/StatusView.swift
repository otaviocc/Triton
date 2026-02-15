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

struct StatusView: View {

    // MARK: - Properties

    @Environment(\.openURL) private var openURL
    @Environment(\.viewModelFactory) private var viewModelFactory

    private let viewModel: StatusViewModel

    // MARK: - Lifecycle

    init(
        viewModel: StatusViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack(alignment: .top) {
            makeIconView()

            VStack(alignment: .leading, spacing: 4) {
                AddressView(address: viewModel.address)
                makeMessageView()

                HStack {
                    makeClockView()
                    Spacer()
                    makeReplyView()
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .card(viewModel.backgroundColorID)
        .contextMenu {
            makeContextualMenu()
        }
    }

    private func makeIconView() -> some View {
        Text(viewModel.icon)
            .font(.system(size: 56))
            .frame(width: 60, height: 60)
    }

    private func makeMessageView() -> some View {
        Text(LocalizedStringKey(viewModel.message))
            .font(.body)
            .foregroundStyle(.black)
            .environment(\.openURL, OpenURLAction { url in
                openURL(url)
                return .handled
            })
    }

    private func makeClockView() -> some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .foregroundStyle(.black)
                .font(.subheadline)

            Text(viewModel.relativeDate)
                .font(.subheadline)
                .foregroundStyle(.black)
        }
    }

    @ViewBuilder
    private func makeReplyView() -> some View {
        if viewModel.replyURL != nil {
            Image(systemName: "message")
                .foregroundStyle(.black)
                .font(.subheadline)
        }
    }

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeCopyStatusURLToClipboard()
        if viewModel.replyURL != nil {
            makeCopyReplyURLToClipboard()
        }
        Divider()
        makeOpenInBrowserItem()
        if viewModel.replyURL != nil {
            makeOpenReplyInBrowserItem()
        }
        Divider()
        makeMuteAddressItem()
    }

    private func makeOpenInBrowserItem() -> some View {
        Button {
            openURL(viewModel.statusURL)
        } label: {
            Label("Open in Browser", systemImage: "safari")
        }
    }

    @ViewBuilder
    private func makeOpenReplyInBrowserItem() -> some View {
        if let replyURL = viewModel.replyURL {
            Button {
                openURL(replyURL)
            } label: {
                Label("Open Reply in Browser", systemImage: "message")
            }
        }
    }

    private func makeMuteAddressItem() -> some View {
        Button {
            viewModel.muteAddress()
        } label: {
            Label(
                "Mute All @\(viewModel.address)'s Posts",
                systemImage: "speaker.slash.fill"
            )
        }
    }

    private func makeCopyStatusURLToClipboard() -> some View {
        Button {
            viewModel.copyStatusURLToClipboard()
        } label: {
            Label("Copy Status URL", systemImage: "link")
        }
    }

    private func makeCopyReplyURLToClipboard() -> some View {
        Button {
            viewModel.copyReplyURLToClipboard()
        } label: {
            Label("Copy Reply URL", systemImage: "link")
        }
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        StatusView(
            viewModel: StatusViewModelMother.makeStatusViewModel()
        )
        .frame(width: 420)
    }

#endif

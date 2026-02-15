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

import StatusPersistenceService
import StatusRepository
import SwiftData
import SwiftUI

struct StatusSettingsView: View {

    // MARK: - Properties

    @State private var viewModel: StatusSettingsViewModel
    @Query(MutedAddress.fetchDescriptor()) private var mutedAddresses: [MutedAddress]
    @Query(MutedKeyword.fetchDescriptor()) private var mutedKeywords: [MutedKeyword]

    // MARK: - Lifecycle

    init(
        viewModel: StatusSettingsViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        Form {
            makeMutedAddressesSection()
            makeMutedKeywordsSection()
        }
        .formStyle(.grouped)
    }

    // MARK: - Private

    private func makeMutedAddressesSection() -> some View {
        Section {
            makeMuteSection(
                placeholder: "Address to mute",
                inputText: $viewModel.newAddress,
                emptyMessage: "No muted addresses",
                items: mutedAddresses,
                itemText: \.address,
                addAction: viewModel.muteAddress,
                removeAction: viewModel.unmuteAddress
            )
        } header: {
            Text("Muted Addresses")
        } footer: {
            Text("Status updates from these addresses will not appear in your timeline.")
        }
    }

    private func makeMutedKeywordsSection() -> some View {
        Section {
            makeMuteSection(
                placeholder: "Keyword to mute",
                inputText: $viewModel.newKeyword,
                emptyMessage: "No muted keywords",
                items: mutedKeywords,
                itemText: \.keyword,
                addAction: viewModel.muteKeyword,
                removeAction: viewModel.unmuteKeyword
            )
        } header: {
            Text("Muted Keywords")
        } footer: {
            Text("Status updates containing these keywords will not appear in your timeline.")
        }
    }

    @ViewBuilder
    private func makeMuteSection<Item: Hashable>(
        placeholder: String,
        inputText: Binding<String>,
        emptyMessage: String,
        items: [Item],
        itemText: KeyPath<Item, String>,
        addAction: @escaping () -> Void,
        removeAction: @escaping (String) -> Void
    ) -> some View {
        HStack {
            TextField(placeholder, text: inputText)
                .textFieldCard()
                .onSubmit {
                    addAction()
                }

            Button("Add") {
                addAction()
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                inputText
                    .wrappedValue
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty
            )
        }

        if items.isEmpty {
            Text(emptyMessage)
                .foregroundStyle(.secondary)
                .italic()
        } else {
            ForEach(items, id: \.self) { item in
                let text = item[keyPath: itemText]
                HStack {
                    Text(text)
                    Spacer()
                    Button {
                        removeAction(text)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Unmute \(text)")
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        StatusSettingsView(
            viewModel: .init(
                repository: StatusRepositoryMother.makeStatusRepository()
            )
        )
    }

#endif

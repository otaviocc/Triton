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

    @ViewBuilder
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

    @ViewBuilder
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

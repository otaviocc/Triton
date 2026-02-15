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

import Foundation
import Observation
import PURLsRepository
import SessionServiceInterface

@MainActor
@Observable
final class AddPURLViewModel {

    // MARK: - Properties

    var name = ""
    var urlString = ""
    var selectedAddress = ""
    var shouldDismiss = false
    private(set) var addresses: [String] = []
    private(set) var isSubmitting = false

    private let repository: any PURLsRepositoryProtocol
    private let sessionService: any SessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let isNameEmpty = trimmedName.isEmpty
        let isURLInvalid = !urlString.hasPrefix("http://") && !urlString
            .hasPrefix("https://") || URL(string: urlString) == nil
        return isNameEmpty || isURLInvalid || isSubmitting
    }

    var showAddressesPicker: Bool {
        !addresses.isEmpty && !selectedAddress.isEmpty
    }

    // MARK: - Lifecycle

    init(
        name: String = "",
        urlString: String = "",
        repository: any PURLsRepositoryProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.name = name
        self.urlString = urlString
        self.repository = repository
        self.sessionService = sessionService

        observeSessionChanges()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Public

    func addPURL() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.addPURL(
                    address: selectedAddress,
                    name: name,
                    url: urlString
                )
                shouldDismiss = true
            } catch {
                // Error handled by defer
            }
        }
    }

    // MARK: - Private

    private func observeSessionChanges() {
        observationTask = Task { [weak self] in
            guard let self else { return }

            for await session in sessionService.observeSession() {
                await MainActor.run {
                    switch session {
                    case let .session(currentAccount, selectedAddress):
                        self.handleAddresses(
                            from: currentAccount,
                            with: selectedAddress
                        )
                    default:
                        self.handleMissingAddresses()
                    }
                }
            }
        }
    }

    private func handleMissingAddresses() {
        addresses = []
        selectedAddress = ""
    }

    private func handleAddresses(
        from account: CurrentAccount,
        with selection: SelectedAddress
    ) {
        guard !account.addresses.isEmpty else {
            return handleMissingAddresses()
        }

        addresses = account.addresses.map(\.address)
        selectedAddress = selection
    }
}

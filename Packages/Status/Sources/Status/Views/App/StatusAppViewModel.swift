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

import AuthSessionServiceInterface
import Foundation
import Observation
import SessionServiceInterface

@MainActor
@Observable
final class StatusAppViewModel {

    // MARK: - Properties

    private(set) var disableComposeButton = true

    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.authSessionService = authSessionService
        self.sessionService = sessionService

        observeSessionChanges()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Private

    private func observeSessionChanges() {
        observationTask = Task { [weak self] in
            guard let self else { return }

            let initialLoggedIn = await authSessionService.isLoggedIn
            var hasAddresses = false

            let accountTask = Task { [weak self] in
                guard let self else { return }
                for await account in sessionService.observeAccount() {
                    let hasAddr: Bool = switch account {
                    case .notSynchronized:
                        false
                    case let .account(current):
                        !current.addresses.isEmpty
                    }

                    hasAddresses = hasAddr
                    let isLoggedIn = await authSessionService.isLoggedIn
                    await MainActor.run {
                        self.disableComposeButton = !isLoggedIn || !hasAddresses
                    }
                }
            }

            disableComposeButton = !initialLoggedIn || !hasAddresses

            for await isLoggedIn in authSessionService.observeLoginState() {
                disableComposeButton = !isLoggedIn || !hasAddresses
            }

            accountTask.cancel()
        }
    }
}

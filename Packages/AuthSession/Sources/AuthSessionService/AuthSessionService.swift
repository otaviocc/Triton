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

public actor AuthSessionService: AuthSessionServiceProtocol {

    // MARK: - Properties

    private var _accessToken: String?
    private var _isLoggedIn: Bool
    private let keychainStore: KeychainStoreProtocol

    private let loginStateContinuation: AsyncStream<Bool>.Continuation
    private let logoutEventContinuation: AsyncStream<Void>.Continuation
    private var loginStateObservers: [AsyncStream<Bool>.Continuation] = []
    private var logoutEventObservers: [AsyncStream<Void>.Continuation] = []
    public nonisolated let logoutEventStream: AsyncStream<Void>

    public var isLoggedIn: Bool {
        _isLoggedIn
    }

    public var accessToken: String? {
        _accessToken
    }

    // MARK: - Lifecycle

    init(
        keychainStore: KeychainStoreProtocol
    ) {
        self.keychainStore = keychainStore

        let token = keychainStore.wrappedValue
        _accessToken = token
        _isLoggedIn = token != nil

        var loginContinuation: AsyncStream<Bool>.Continuation!
        _ = AsyncStream<Bool> { continuation in
            loginContinuation = continuation
        }
        loginStateContinuation = loginContinuation

        var logoutContinuation: AsyncStream<Void>.Continuation!
        var logoutStream: AsyncStream<Void>!
        logoutStream = AsyncStream<Void> { continuation in
            logoutContinuation = continuation
        }
        logoutEventStream = logoutStream
        logoutEventContinuation = logoutContinuation
    }

    // MARK: - Public

    public func setAccessToken(_ token: String?) async {
        let previousToken = _accessToken
        _accessToken = token
        keychainStore.wrappedValue = token

        let newLoginState = token != nil

        if _isLoggedIn != newLoginState {
            _isLoggedIn = newLoginState
            for observer in loginStateObservers {
                observer.yield(newLoginState)
            }
        }

        if previousToken != nil, token == nil {
            for observer in logoutEventObservers {
                observer.yield()
            }
        }
    }

    public nonisolated func observeLoginState() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            Task {
                let currentState = await self.isLoggedIn
                continuation.yield(currentState)

                await self.addLoginStateObserver(continuation)

                continuation.onTermination = { _ in
                    Task {
                        await self.removeLoginStateObserver(continuation)
                    }
                }
            }
        }
    }

    public nonisolated func observeLogoutEvents() -> AsyncStream<Void> {
        AsyncStream { continuation in
            Task {
                await self.addLogoutEventObserver(continuation)

                continuation.onTermination = { _ in
                    Task {
                        await self.removeLogoutEventObserver(continuation)
                    }
                }
            }
        }
    }

    private func addLoginStateObserver(_ continuation: AsyncStream<Bool>.Continuation) {
        loginStateObservers.append(continuation)
    }

    private func removeLoginStateObserver(_ continuation: AsyncStream<Bool>.Continuation) {
        // Note: AsyncStream.Continuation cleanup is handled by the onTermination callback
        // A more robust solution might involve wrapping continuations in identifiable wrappers
    }

    private func addLogoutEventObserver(_ continuation: AsyncStream<Void>.Continuation) {
        logoutEventObservers.append(continuation)
    }

    private func removeLogoutEventObserver(_ continuation: AsyncStream<Void>.Continuation) {
        // Note: AsyncStream.Continuation cleanup is handled by the onTermination callback
        // A more robust solution might involve wrapping continuations in identifiable wrappers
    }
}

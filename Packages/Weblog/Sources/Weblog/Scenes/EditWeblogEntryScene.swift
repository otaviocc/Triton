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

import Route
import SwiftUI

struct EditWeblogEntryScene: Scene {

    // MARK: - Properties

    private let environment: WeblogEnvironment

    // MARK: - Lifecycle

    init(
        environment: WeblogEnvironment
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            EditWeblogEntryWindow.name,
            id: EditWeblogEntryWindow.id,
            for: EditWeblogEntry.self
        ) { $entry in
            makeEditorView(
                body: entry?.body ?? "",
                date: entry?.date ?? .init(),
                entryID: entry?.entryID,
                status: entry?.status.flatMap(WeblogEntryStatus.init) ?? .draft,
                tags: entry?.tags ?? .init(),
                address: entry?.address ?? ""
            )
        }
        .windowResizability(.contentSize)
        #if os(macOS)
            .commandsRemoved()
            .defaultPosition(.center)
        #endif
    }

    // MARK: - Private

    @ViewBuilder
    private func makeEditorView(
        body: String,
        date: Date,
        entryID: String?,
        status: WeblogEntryStatus,
        tags: [String],
        address: String
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makeEditWeblogEntryViewModel(
                address: address,
                body: body,
                date: date,
                entryID: entryID,
                status: status,
                tags: tags
            )

        EditorView(
            viewModel: viewModel
        )
        .modelContainer(environment.modelContainer)
        .frame(minWidth: 640, idealWidth: 640, maxWidth: 800)
    }
}

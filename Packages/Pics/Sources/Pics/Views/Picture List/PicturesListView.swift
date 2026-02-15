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
import PicsPersistenceService
import SwiftData
import SwiftUI

struct PicturesListView: View {

    // MARK: - Properties

    @State private var viewModel: PicturesListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var pictures: [SomePicture]

    // MARK: - Lifecycle

    init(
        viewModel: PicturesListViewModel
    ) {
        self.viewModel = viewModel

        _pictures = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Public

    var body: some View {
        Group {
            if pictures.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.somePics)
            } else {
                makePicturesView()
            }
        }
        .scrollContentBackground(.hidden)
        .task {
            try? await viewModel.fetchPictures()
        }
    }

    // MARK: - Private

    private func makePicturesView() -> some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 200))
            ]) {
                ForEach(pictures, id: \.id) { picture in
                    PictureContainer(picture: picture)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Private

private struct PictureContainer: View {

    // MARK: - Properties

    let picture: SomePicture
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makePictureViewModel(
            picture: picture
        )

        PictureView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("With Content") {
        let repository = PicsRepositoryMother.makePicsRepository()
        let environment = PicsEnvironmentMother.makePicsEnvironment()

        PicturesListView(
            viewModel: .init(
                address: "otaviocc",
                repository: repository
            )
        )
        .frame(width: 500, height: 500)
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.picturesContainer.mainContext)
    }

    #Preview("Without Content") {
        let repository = PicsRepositoryMother.makePicsRepository(count: 0)
        let environment = PicsEnvironmentMother.makePicsEnvironment()

        PicturesListView(
            viewModel: .init(
                address: "otaviocc",
                repository: repository
            )
        )
        .frame(width: 500, height: 500)
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.picturesContainer.mainContext)
    }

#endif

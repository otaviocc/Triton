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
import PhotosUI
import PicsPersistenceService
import SwiftData
import SwiftUI

struct UploadView: View {

    // MARK: - Properties

    @State private var selectedItem: PhotosPickerItem?
    @State private var viewModel: UploadViewModel
    @Environment(\.dismiss) private var dismiss
    @Query(SomeTag.fetchDescriptor()) private var existingTags: [SomeTag]

    // MARK: - Computed Properties

    private var existingTagTitles: [String] {
        existingTags.map(\.title)
    }

    // MARK: - Lifecycle

    init(
        viewModel: UploadViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        makeContentView()
            .toolbar {
                makeToolbarContent()
            }
            .navigationTitle("")
            .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
            .padding()
    }

    // MARK: - Private

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        Task {
            await viewModel.handleImageDrop(providers: providers)
        }
        return true
    }

    private func makeContentView() -> some View {
        VStack {
            HStack(alignment: .top) {
                makeSidebarView()
                    .frame(width: 200)
                makeEditorView()
            }
            makeVisibilityView()
        }
    }

    private func makeSidebarView() -> some View {
        VStack {
            if viewModel.imageData != nil {
                makePictureView()
                makeRemoveButtonView()
            } else {
                ZStack {
                    makeDropZoneBorder()
                    makeDropZoneContentView()
                }
                .onDrop(of: [.image], isTargeted: $viewModel.isDragging) { providers -> Bool in
                    handleDrop(providers: providers)
                }
            }
        }
    }

    private func makeDropZoneBorder() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                AnyShapeStyle(
                    viewModel.isDragging ? Color.accentColor.opacity(0.3) : .secondary.opacity(0.05)
                )
            )
            .stroke(Color.accentColor, lineWidth: 1.0)
            .opacity(0.3)
            .frame(minHeight: 200)
    }

    private func makeDropZoneContentView() -> some View {
        VStack(spacing: 12) {
            Image(systemName: viewModel.dropZoneImageName)
                .font(.system(size: 48))
                .foregroundStyle(viewModel.isDragging ? Color.accentColor : .secondary)

            if !viewModel.isDragging {
                Text("Drag your picture here or click the button to select one from your Photo Library")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                makePicturePickerView()
            }
        }
        .padding(.vertical, 16)
    }

    @ViewBuilder
    private func makePictureView() -> some View {
        if let cgImage = viewModel.imageData?.cgImage {
            Image(cgImage, scale: 1.0, label: Text("Selected Image"))
                .resizable()
                .scaledToFit()
                .clipped()
                .clipShape(.rect(cornerRadius: 8))
        }
    }

    private func makePicturePickerView() -> some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Text("Select from Library")
        }
        .help("Choose an image from your photo library")
        .onChange(of: selectedItem) {
            Task {
                viewModel.imageData = try? await selectedItem?.loadTransferable(type: Data.self)
            }
        }
        .buttonStyle(.borderedProminent)
    }

    private func makeRemoveButtonView() -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.imageData = nil
                selectedItem = nil
            }
        } label: {
            Label("Remove", systemImage: "trash")
        }
        .help("Remove selected image")
        .buttonStyle(.bordered)
    }

    private func makeEditorView() -> some View {
        VStack {
            PlaceholderTextEditor(
                placeholder: "Caption",
                text: $viewModel.caption,
                help: "Add a caption for your image"
            )

            PlaceholderTextEditor(
                placeholder: "Alt text",
                text: $viewModel.altText,
                help: "Add descriptive alt text for accessibility"
            )

            makeTagsView()
        }
    }

    private func makeTagsView() -> some View {
        VStack(alignment: .leading) {
            makeTagInputView()
            makeTagSuggestionsView()
            makeSelectedTagsView()
        }
    }

    private func makeTagInputView() -> some View {
        TextField("Add tag", text: $viewModel.tagInput)
            .autocorrectionDisabled(true)
            .font(.body.monospaced())
            .textFieldCard()
            .help("Enter a tag and press the return key to add it, or press tab to select the first suggestion")
            .onSubmit {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.addTag(viewModel.tagInput)
                }
            }
            .onChange(of: viewModel.tagInput) {
                viewModel.updateTagSuggestions(from: existingTagTitles)
            }
            .onKeyPress(.tab) {
                do {
                    try viewModel.selectFirstTagSuggestion()
                    return .handled
                } catch {
                    return .ignored
                }
            }
    }

    @ViewBuilder
    private func makeTagSuggestionsView() -> some View {
        if !viewModel.suggestedTags.isEmpty {
            TagListView(
                tags: viewModel.suggestedTags,
                helpText: { "Add existing tag '\($0)'" },
                action: { tag in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.addTag(tag)
                    }
                }
            )
        }
    }

    @ViewBuilder
    private func makeSelectedTagsView() -> some View {
        if !viewModel.tags.isEmpty {
            TagListView(
                tags: viewModel.tags,
                style: .remove,
                helpText: { "Remove tag '\($0)'" },
                action: { tag in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.removeTag(tag)
                    }
                }
            )
        }
    }

    private func makeVisibilityView() -> some View {
        HStack {
            Spacer()
            Toggle("Hidden from Public?", isOn: $viewModel.isHidden)
                .help("Hide image from public gallery")
        }
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup {
            if viewModel.shouldShowProgress {
                ProgressToolbarItem()
            }
            if viewModel.showAddressesPicker {
                AddressPickerToolbarItem(
                    addresses: viewModel.addresses,
                    selection: $viewModel.selectedAddress,
                    helpText: "Select address for picture upload"
                )
            }
            makeUploadPictureToolbarItem()
        }
    }

    private func makeUploadPictureToolbarItem() -> some View {
        Button {
            viewModel.uploadPicture()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Upload picture")
        .disabled(viewModel.isSubmitDisabled)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("Without Data") {
        UploadView(
            viewModel: UploadViewModelMother.makeUploadViewModel()
        )
    }

    #Preview("With Data") {
        UploadView(
            viewModel: UploadViewModelMother.makeUploadViewModel(
                caption: "This is the photo caption",
                altText: "This is a very long alt text for the image, describing the image.",
                isHidden: false,
                tags: ["foo", "bar"],
                imageData: DataMother.makeSquareImageData()
            )
        )
    }

    #Preview("Drag-And-Drop") {
        UploadView(
            viewModel: UploadViewModelMother.makeUploadViewModel(
                isDragging: true
            )
        )
    }

#endif

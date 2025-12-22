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
            .onDrop(of: [.image], isTargeted: $viewModel.isDragging) { providers -> Bool in
                handleDrop(providers: providers)
            }
    }

    // MARK: - Private

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        Task {
            await viewModel.handleImageDrop(providers: providers)
        }
        return true
    }

    @ViewBuilder
    private func makeSidebarView() -> some View {
        VStack {
            makePictureView()
            makePicturePickerView()
        }
    }

    @ViewBuilder
    private func makeContentView() -> some View {
        ZStack {
            if viewModel.isDragging {
                makeDropZoneView()
            } else {
                VStack {
                    HStack(alignment: .top) {
                        makeSidebarView()
                            .frame(width: 200)
                        makeEditorView()
                    }
                    makeVisibilityView()
                }
            }
        }
    }

    @ViewBuilder
    private func makeDropZoneView() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                AnyShapeStyle(
                    viewModel.isDragging ? Color.accentColor.opacity(0.1) : .clear
                )
            )
            .strokeBorder(
                viewModel.isDragging ? Color.accentColor : .secondary.opacity(0.3),
                style: StrokeStyle(lineWidth: 2, dash: [8, 4])
            )
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

    @ViewBuilder
    private func makePicturePickerView() -> some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Text("Select Picture")
        }
        .help("Choose an image from your photo library")
        .onChange(of: selectedItem) {
            Task {
                viewModel.imageData = try? await selectedItem?.loadTransferable(type: Data.self)
            }
        }
        .buttonStyle(.borderedProminent)
    }

    @ViewBuilder
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

    @ViewBuilder
    private func makeTagsView() -> some View {
        VStack(alignment: .leading) {
            makeTagInputView()
            makeTagSuggestionsView()
            makeSelectedTagsView()
        }
    }

    @ViewBuilder
    private func makeTagInputView() -> some View {
        TextField("Add tag", text: $viewModel.tagInput)
            .autocorrectionDisabled(true)
            .font(.body.monospaced())
            .textFieldCard()
            .help("Enter a tag and press the return key to add it")
            .onSubmit {
                withAnimation {
                    viewModel.addTag(viewModel.tagInput)
                }
            }
            .onChange(of: viewModel.tagInput) {
                viewModel.updateTagSuggestions(from: existingTags.map(\.title))
            }
    }

    @ViewBuilder
    private func makeTagSuggestionsView() -> some View {
        if !viewModel.suggestedTags.isEmpty {
            TagListView(
                tags: viewModel.suggestedTags,
                helpText: { "Add existing tag '\($0)'" }
            ) { tag in
                withAnimation {
                    viewModel.addTag(tag)
                }
            }
        }
    }

    @ViewBuilder
    private func makeSelectedTagsView() -> some View {
        if !viewModel.tags.isEmpty {
            TagListView(
                tags: viewModel.tags,
                style: .remove,
                helpText: { "Remove tag '\($0)'" }
            ) { tag in
                withAnimation {
                    viewModel.removeTag(tag)
                }
            }
        }
    }

    @ViewBuilder
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

    @ViewBuilder
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

#endif

import FoundationExtensions
import SwiftUI

/// A SwiftUI view that provides an emoji picker interface with category browsing and search functionality.
public struct EmojiPickerView: View {

    // MARK: - Properties

    @State private var viewModel = EmojiPickerViewModel()
    @Environment(\.presentationMode) private var presentationMode

    private var isPresented: Binding<Bool>
    private let binding: Binding<String>
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Lifecycle

    /// Initializes the emoji picker view.
    ///
    /// - Parameters:
    ///   - biding: A binding to the string that will receive the selected emoji.
    ///   - isPresented: A binding to control the presentation state of the picker.
    public init(
        binding: Binding<String>,
        isPresented: Binding<Bool>
    ) {
        self.binding = binding
        self.isPresented = isPresented
    }

    // MARK: - Public

    public var body: some View {
        VStack {
            ScrollViewReader { proxy in
                makeCategoriesView(proxy: proxy)
                    .disabled(viewModel.isSearching)

                ScrollView {
                    if viewModel.isSearching {
                        makeEmojiSearchResultsView()
                    } else {
                        makeEmojiSectionsView()
                    }
                }

                makeSearchView()
            }
        }
        .padding()
        .background()
    }

    // MARK: - Private

    @ViewBuilder
    private func makeCategoriesView(
        proxy: ScrollViewProxy
    ) -> some View {
        HStack(spacing: 12) {
            ForEach(Emoji.Category.allCases) { section in
                Button {
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(section.id, anchor: .top)
                    }
                } label: {
                    Image(systemName: section.iconName)
                        .help(section.description)
                }
                .background()
                .buttonStyle(.borderless)
            }
        }
    }

    @ViewBuilder
    private func makeEmojiSectionsView() -> some View {
        LazyVGrid(columns: columns, pinnedViews: .sectionHeaders) {
            ForEach(Emoji.Category.allCases) { section in
                makeEmojiSectionView(category: section)
            }
        }
    }

    @ViewBuilder
    private func makeEmojiSectionView(
        category: Emoji.Category
    ) -> some View {
        let emojis = viewModel.emojis.filter {
            $0.category == category
        }

        Section {
            ForEach(emojis, id: \.id) { emoji in
                makeEmojiIcon(emoji: emoji)
            }
        } header: {
            HStack {
                Text(category.rawValue)
                    .textCase(.uppercase)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .id(category.id)
                Spacer()
            }
            .padding([.top, .bottom], 2)
            .background()
        }
    }

    @ViewBuilder
    private func makeEmojiSearchResultsView() -> some View {
        let filteredEmojis = viewModel.emojis.filter {
            $0.keywords.containsPartial(viewModel.searchTerm)
        }

        LazyVGrid(columns: columns, pinnedViews: .sectionHeaders) {
            ForEach(filteredEmojis, id: \.id) { emoji in
                makeEmojiIcon(
                    emoji: emoji
                )
            }
        }
    }

    @ViewBuilder
    private func makeSearchView() -> some View {
        TextField("Search", text: $viewModel.searchTerm)
            .search(searchTerm: $viewModel.searchTerm)
    }

    @ViewBuilder
    private func makeEmojiIcon(
        emoji: Emoji
    ) -> some View {
        Text(emoji.emoji)
            .font(.largeTitle)
            .help(emoji.description)
            .onTapGesture {
                withAnimation {
                    binding.wrappedValue = emoji.emoji
                }
                isPresented.wrappedValue = false
            }
    }
}

// MARK: - Preview

#Preview {
    EmojiPickerView(
        binding: .constant(""),
        isPresented: .constant(true)
    )
    .frame(width: 300)
}

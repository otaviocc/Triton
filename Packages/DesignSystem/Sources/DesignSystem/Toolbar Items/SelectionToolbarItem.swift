import SwiftUI

// MARK: - Style Protocol

/// A protocol that defines the visual style of a selection toolbar item.
///
/// Conform to this protocol to create custom styles for `SelectionToolbarItem`.
/// The style determines the icon and default help text displayed in the toolbar.
///
/// ## Creating a Custom Style
///
/// ```swift
/// struct CustomSelectionToolbarItemStyle: SelectionToolbarItemStyle {
///     func makeLabel(helpText: LocalizedStringKey) -> some View {
///         Image(systemName: "star")
///             .help(helpText)
///     }
///
///     var defaultHelpText: LocalizedStringKey {
///         "Select option"
///     }
/// }
/// ```
public protocol SelectionToolbarItemStyle: Sendable {

    /// The type of view representing the label.
    associatedtype Label: View

    /// Creates the label view for the toolbar item.
    ///
    /// - Parameter helpText: The help text to display on hover.
    /// - Returns: A view representing the toolbar item's icon.
    @ViewBuilder
    func makeLabel(helpText: LocalizedStringKey) -> Label

    /// The default help text for this style.
    var defaultHelpText: LocalizedStringKey { get }
}

// MARK: - Filter Style

/// A style that displays a filter icon (three horizontal lines with decrease symbol).
public struct FilterSelectionToolbarItemStyle: SelectionToolbarItemStyle {

    public init() {}

    public func makeLabel(helpText: LocalizedStringKey) -> some View {
        Image(systemName: "line.3.horizontal.decrease")
            .help(helpText)
    }

    public var defaultHelpText: LocalizedStringKey {
        "Filter items"
    }
}

// MARK: - Sort Style

/// A style that displays a sort icon (up and down arrows).
public struct SortSelectionToolbarItemStyle: SelectionToolbarItemStyle {

    public init() {}

    public func makeLabel(helpText: LocalizedStringKey) -> some View {
        Image(systemName: "arrow.up.arrow.down")
            .help(helpText)
    }

    public var defaultHelpText: LocalizedStringKey {
        "Sort items"
    }
}

// MARK: - Environment Key

private struct SelectionToolbarItemStyleKey: EnvironmentKey {

    static let defaultValue: any SelectionToolbarItemStyle = FilterSelectionToolbarItemStyle()
}

extension EnvironmentValues {

    var selectionToolbarItemStyle: any SelectionToolbarItemStyle {
        get { self[SelectionToolbarItemStyleKey.self] }
        set { self[SelectionToolbarItemStyleKey.self] = newValue }
    }
}

// MARK: - View Extension

public extension View {

    /// Sets the style for selection toolbar items within this view.
    ///
    /// - Parameter style: The style to apply to selection toolbar items.
    /// - Returns: A view with the specified selection toolbar item style applied.
    ///
    /// ## Example
    ///
    /// ```swift
    /// SelectionToolbarItem(
    ///     options: Filter.allCases,
    ///     selection: $filter,
    ///     itemLabel: { $0.title }
    /// )
    /// .selectionToolbarItemStyle(FilterSelectionToolbarItemStyle())
    /// ```
    func selectionToolbarItemStyle(_ style: some SelectionToolbarItemStyle) -> some View {
        environment(\.selectionToolbarItemStyle, style)
    }
}

// MARK: - Selection Toolbar Item

/// A toolbar item that displays a dropdown menu for selecting from various options.
///
/// `SelectionToolbarItem` is a generic, reusable component that can be styled using
/// the `.selectionToolbarItemStyle()` modifier. It's designed to work with any
/// `Hashable & CaseIterable` type.
///
/// The visual appearance (icon and default help text) is determined by the applied style.
/// Use `FilterSelectionToolbarItemStyle` for filtering or `SortSelectionToolbarItemStyle`
/// for sorting, or create custom styles conforming to `SelectionToolbarItemStyle`.
///
/// ## Example Usage
///
/// ```swift
/// enum ContentFilter: String, CaseIterable {
///     case all, today, thisWeek
///
///     var title: String {
///         switch self {
///         case .all: return "All"
///         case .today: return "Today"
///         case .thisWeek: return "This Week"
///         }
///     }
/// }
///
/// SelectionToolbarItem(
///     options: ContentFilter.allCases,
///     selection: $selectedFilter,
///     itemLabel: { $0.title }
/// )
/// .selectionToolbarItemStyle(FilterSelectionToolbarItemStyle())
/// ```
public struct SelectionToolbarItem<Option: Hashable & CaseIterable>: View {

    // MARK: - Properties

    @Environment(\.selectionToolbarItemStyle) private var style

    private let options: [Option]
    private let selection: Binding<Option>
    private let itemLabel: (Option) -> String
    private let helpText: LocalizedStringKey?

    // MARK: - Lifecycle

    /// Creates a new selection toolbar item.
    ///
    /// - Parameters:
    ///   - options: An array of options to display in the dropdown menu. Typically
    ///     populated using `Option.allCases` for enum-based options.
    ///   - selection: A binding to the currently selected option. This binding is
    ///     updated when the user selects a different option from the dropdown.
    ///   - itemLabel: A closure that converts an option to its display string.
    ///   - helpText: Optional custom help text shown when hovering over the icon.
    ///     If `nil`, the style's default help text is used.
    public init(
        options: [Option],
        selection: Binding<Option>,
        itemLabel: @escaping (Option) -> String,
        helpText: LocalizedStringKey? = nil
    ) {
        self.options = options
        self.selection = selection
        self.itemLabel = itemLabel
        self.helpText = helpText
    }

    // MARK: - Public

    public var body: some View {
        DropdownMenuView(
            options: options,
            selection: selection,
            itemLabel: itemLabel,
            label: {
                AnyView(style.makeLabel(helpText: helpText ?? style.defaultHelpText))
            }
        )
    }
}

import DesignSystem
import Route
import SwiftUI

struct SidebarView: View {

    // MARK: - Properties

    @State private var viewModel: SidebarViewModel

    private var selection: Binding<RouteFeature?>

    // MARK: - Lifecycle

    init(
        viewModel: SidebarViewModel,
        selection: Binding<RouteFeature?>
    ) {
        self.viewModel = viewModel
        self.selection = selection
    }

    // MARK: - Public

    var body: some View {
        List(selection: selection) {
            makeFeaturesSectionView()
            makeManagementSectionView()
        }
        #if !os(macOS)
        .navigationTitle("Triton")
        #endif
    }

    // MARK: - Private

    @ViewBuilder
    private func makeFeaturesSectionView() -> some View {
        let items = SidebarItem.features

        Section {
            ForEach(items, id: \.self) { item in
                NavigationLink(value: item.destination) {
                    Label(item.label, systemImage: item.systemImageName)
                }
            }
        }
    }

    @ViewBuilder
    private func makeManagementSectionView() -> some View {
        let items = SidebarItem.management(
            isLoggedIn: viewModel.showLogoutButton
        )

        Section {
            ForEach(items, id: \.self) { item in
                NavigationLink(value: item.destination) {
                    Label(item.label, systemImage: item.systemImageName)
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("Logged in") {
        SidebarView(
            viewModel: SidebarViewModelMother.makeSidebarViewModel(
                loggedIn: true
            ),
            selection: .constant(.statuslog)
        )
        .frame(width: 180)
    }

    #Preview("Logged out") {
        SidebarView(
            viewModel: SidebarViewModelMother.makeSidebarViewModel(
                loggedIn: false
            ),
            selection: .constant(.weblog)
        )
        .frame(width: 180)
    }

#endif

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

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

import Foundation

/// Represents the publication status of a weblog entry.
///
/// Status values control how entries are displayed and distributed across
/// the weblog and its feeds. Each status provides different visibility
/// and accessibility options for entries.
enum WeblogEntryStatus: String, CaseIterable, Hashable, Identifiable {

    /// Draft status marks an entry as unpublished.
    ///
    /// Entries with this status are not publicly accessible and are
    /// typically used for work-in-progress content.
    case draft = "Draft"

    /// Live status makes an entry fully published and accessible.
    ///
    /// Entries with this status appear on the weblog, in post lists,
    /// on tag pages, and are included in RSS, Atom, and JSON feeds.
    case live

    /// Feed Only status hides the entry from the web but includes it in feeds.
    ///
    /// Entries with this status are treated as unlisted on the web (not
    /// appearing in post lists, tag pages, or as landing pages) but are
    /// included in RSS, Atom, and JSON feeds.
    case liveRSSOnly = "Feed Only"

    /// Web Only status hides the entry from feeds but keeps it on the web.
    ///
    /// Entries with this status are accessible on the weblog and appear
    /// in post lists and tag pages, but are completely hidden from RSS,
    /// Atom, and JSON feeds.
    case liveWebOnly = "Web Only"

    /// Unlisted status makes an entry accessible only via direct URL.
    ///
    /// Entries with this status are not served as default/landing pages,
    /// do not appear in post lists or recent posts, and are not included
    /// on tag pages. They are only accessible to people who know the
    /// entry's direct URL.
    case unlisted = "Unlisted"

    // MARK: - Properties

    var id: Self {
        self
    }

    var displayName: String {
        rawValue.capitalized
    }
}

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

public extension URL {

    /// The base URL for the Now Garden website.
    ///
    /// Now Garden is a community-driven directory of /now pages, allowing users
    /// to discover what others are currently working on or focused on.
    ///
    /// - Example: `https://now.garden/`
    static let nowGardenURL = URL(string: "https://now.garden/")!

    /// Creates a URL for an OMG.LOL user's main webpage.
    ///
    /// This initializer constructs the primary webpage URL for a given OMG.LOL
    /// address. The webpage serves as the user's main landing page and profile.
    ///
    /// - Parameter address: The OMG.LOL username
    /// - Example: `URL(webpageFor: "alice")` → `https://alice.omg.lol`
    init(
        webpageFor address: String
    ) {
        self.init(
            string: "https://\(address).omg.lol"
        )!
    }

    /// Creates a URL for an OMG.LOL user's /now page.
    ///
    /// This initializer constructs the URL for a user's "now" page, which
    /// typically contains current status, activities, or what they're working on.
    ///
    /// - Parameter address: The OMG.LOL username
    /// - Example: `URL(nowPageFor: "alice")` → `https://alice.omg.lol/now`
    init(
        nowPageFor address: String
    ) {
        self.init(
            string: "https://\(address).omg.lol/now"
        )!
    }

    /// Creates a URL for an OMG.LOL user's weblog homepage.
    ///
    /// This initializer constructs the URL for a user's weblog, which displays
    /// their blog posts and longer-form content on the weblog.lol subdomain.
    ///
    /// - Parameter address: The OMG.LOL username
    /// - Example: `URL(weblogFor: "alice")` → `https://alice.weblog.lol`
    init(
        weblogFor address: String
    ) {
        self.init(
            string: "https://\(address).weblog.lol"
        )!
    }

    /// Creates a URL for the weblog configuration page on the OMG.LOL home site.
    ///
    /// This initializer constructs the URL for accessing a user's weblog
    /// configuration settings on the OMG.LOL home site, where they can manage
    /// weblog appearance, behavior, and other settings.
    ///
    /// - Parameter address: The OMG.LOL username
    /// - Example: `URL(weblogConfigurationFor: "alice")` → `https://home.omg.lol/address/alice/weblog/configuration`
    init(
        weblogConfigurationFor address: String
    ) {
        self.init(
            string: "https://home.omg.lol/address/\(address)/weblog/configuration"
        )!
    }

    /// Creates a URL for a specific weblog entry.
    ///
    /// This initializer constructs the URL for an individual weblog post using
    /// the user's address and the entry's location path.
    ///
    /// - Parameters:
    ///   - address: The OMG.LOL username
    ///   - location: The path to the specific weblog entry
    /// - Example: `URL(weblogPostFor: "alice", location: "/my-post")` → `https://alice.weblog.lol/my-post`
    init(
        weblogPostFor address: String,
        location: String
    ) {
        self.init(
            string: "https://\(address).weblog.lol\(location)"
        )!
    }

    /// Creates a URL for an OMG.LOL user's profile avatar image.
    ///
    /// This initializer constructs the URL for retrieving a user's avatar image
    /// from the OMG.LOL profiles cache service.
    ///
    /// - Parameter address: The OMG.LOL username
    /// - Example: `URL(avatarFor: "alice")` → `https://profiles.cache.lol/alice/picture`
    init(
        avatarFor address: String
    ) {
        self.init(
            string: "https://profiles.cache.lol/\(address)/picture"
        )!
    }

    /// Creates a URL for a specific status post.
    ///
    /// This initializer constructs the URL for an individual status update
    /// on the status.lol subdomain.
    ///
    /// - Parameters:
    ///   - statusID: The unique identifier of the status post
    ///   - address: The OMG.LOL username
    /// - Example: `URL(statusID: "abc123", for: "alice")` → `https://alice.status.lol/abc123`
    init(
        statusID: String,
        for address: String
    ) {
        self.init(
            string: "https://\(address).status.lol/\(statusID)"
        )!
    }

    /// Creates a URL for a PURL (Persistent URL) redirect.
    ///
    /// This initializer constructs the URL for a user's PURL on the url.lol
    /// subdomain, which provides persistent URL redirection services.
    ///
    /// - Parameters:
    ///   - purlName: The name/identifier of the PURL
    ///   - address: The OMG.LOL username
    /// - Example: `URL(purlName: "github", for: "alice")` → `https://alice.url.lol/github`
    init(
        purlName: String,
        for address: String
    ) {
        self.init(
            string: "https://\(address).url.lol/\(purlName)"
        )!
    }

    /// Creates a URL for a paste entry.
    ///
    /// This initializer constructs the URL for a user's paste on the paste.lol
    /// subdomain, which provides code and text sharing functionality.
    ///
    /// - Parameters:
    ///   - pasteTitle: The title/identifier of the paste
    ///   - address: The OMG.LOL username
    /// - Example: `URL(pasteTitle: "my-code", for: "alice")` → `https://alice.paste.lol/my-code`
    init(
        pasteTitle: String,
        for address: String
    ) {
        self.init(
            string: "https://\(address).paste.lol/\(pasteTitle)"
        )!
    }

    /// Creates a URL for an OMG.LOL user's some.pics image hosting page.
    ///
    /// This initializer constructs the URL for a user's image hosting site
    /// on the some.pics subdomain, which provides image sharing and hosting services.
    ///
    /// - Parameter address: The OMG.LOL username
    /// - Example: `URL(somePicsFor: "alice")` → `https://alice.some.pics`
    init(
        somePicsFor address: String
    ) {
        self.init(
            string: "https://\(address).some.pics"
        )!
    }
}

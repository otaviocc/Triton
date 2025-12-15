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

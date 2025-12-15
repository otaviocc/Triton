import Route

enum SidebarItem: CaseIterable {

    case statuslog
    case purls
    case webpage
    case nowPage
    case weblog
    case somePics
    case pastebin
    case account
    case logIn
    case logOut

    // MARK: - Public

    static var features: [SidebarItem] {
        [
            statuslog,
            purls,
            webpage,
            nowPage,
            weblog,
            somePics,
            pastebin
        ]
    }

    static func management(
        isLoggedIn: Bool
    ) -> [SidebarItem] {
        guard isLoggedIn else {
            return [.logIn]
        }

        return [.account, .logOut]
    }

    var label: String {
        switch self {
        case .statuslog: "Statuslog"
        case .purls: "PURLs"
        case .webpage: "Web Page"
        case .nowPage: "Now Page"
        case .weblog: "Weblog"
        case .somePics: "Pics"
        case .pastebin: "Pastebin"
        case .account: "Account"
        case .logIn: "Sign In"
        case .logOut: "Sign Out"
        }
    }

    var destination: RouteFeature {
        switch self {
        case .statuslog: .statuslog
        case .purls: .purls
        case .webpage: .webpage
        case .nowPage: .nowPage
        case .weblog: .weblog
        case .somePics: .somePics
        case .pastebin: .pastebin
        case .account: .account
        case .logIn: .auth
        case .logOut: .auth
        }
    }

    var systemImageName: String {
        switch self {
        case .statuslog: "message"
        case .purls: "link"
        case .webpage: "safari"
        case .nowPage: "clock"
        case .weblog: "text.below.photo"
        case .somePics: "photo"
        case .pastebin: "clipboard"
        case .account: "person.fill"
        case .logIn: "person.fill"
        case .logOut: "rectangle.portrait.and.arrow.right"
        }
    }
}

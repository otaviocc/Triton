import Account
import AccountUpdateService
import Auth
import AuthSessionService
import AuthSessionServiceInterface
import ClipboardService
import MicroClient
import MicroContainer
import Now
import OMGAPI
import Pastebin
import Pics
import PURLs
import SessionService
import SessionServiceInterface
import Shortcuts
import Sidebar
import Status
import Weblog
import Webpage

/// The main dependency injection container protocol for the OMG application.
///
/// `TritonEnvironmentProtocol` defines the contract for resolving and providing access
/// to all core application dependencies. It serves as the central hub for dependency
/// injection, ensuring that shared services and feature-specific app factories are
/// available throughout the application lifecycle.
///
/// ## Architecture
///
/// The protocol follows a modular architecture pattern where:
/// - **Core Services**: Shared infrastructure services used across multiple features
/// - **App Factories**: Feature-specific factories that create complete app modules
/// - **Dependency Resolution**: All dependencies are resolved through a container-based system
///
/// ## Core Services
///
/// The protocol provides access to fundamental services that are shared across features:
/// - Authentication and session management
/// - Network communication
/// - User session state
///
/// ## Feature Factories
///
/// Each major application feature has its own dedicated factory that encapsulates
/// all the dependencies needed for that feature area:
/// - Status updates and timeline management
/// - User authentication flows
/// - Account management and profile settings
/// - PURLs (permanent URL) creation and management
/// - "Now page" content editing
/// - Web page creation and editing
/// - Pastebin functionality
/// - Weblog posting and management
/// - Application sidebar navigation
///
/// ## Usage
///
/// Conforming types should handle dependency registration and resolution internally,
/// typically using a dependency injection container:
///
/// ```swift
/// struct MyEnvironment: TritonEnvironmentProtocol {
///     private let container = DependencyContainer()
///
///     var authSessionService: any AuthSessionServiceProtocol {
///         container.resolve()
///     }
///
///     // ... other dependencies
/// }
/// ```
///
/// ## Thread Safety
///
/// All properties should be thread-safe and support concurrent access since they
/// may be accessed from multiple contexts throughout the application.
protocol TritonEnvironmentProtocol {

    // MARK: - Core Services

    /// Provides authentication session management and token handling.
    ///
    /// Used for managing user authentication state, storing and retrieving
    /// access tokens, and handling authentication lifecycle events.
    var authSessionService: any AuthSessionServiceProtocol { get }

    /// Provides user session state management across the application.
    ///
    /// Manages the current user's session information, selected addresses,
    /// and session-related state that needs to be shared between features.
    var sessionService: any SessionServiceProtocol { get }

    /// Provides network communication capabilities for API requests.
    ///
    /// Configured with authentication token providers and handles all
    /// HTTP communication with the OMG API services.
    var networkClient: any NetworkClientProtocol { get }

    /// Provides App Intent integration for Spotlight, Siri, and Shortcuts.
    ///
    /// Observes notifications posted by App Intents and coordinates window
    /// opening actions, bridging system-level shortcuts to the application UI.
    var shortcutsService: any ShortcutsServiceProtocol { get }

    /// Provides clipboard capabilities.
    ///
    /// Used for adding URLs, Markdown content, and more to the system's
    /// pasteboard.
    var clipboardService: any ClipboardServiceProtocol { get }

    // MARK: - Feature App Factories

    /// Factory for creating Status feature components.
    ///
    /// Provides access to status posting, timeline viewing, and status
    /// management functionality.
    var statusAppFactory: StatusAppFactory { get }

    /// Factory for creating Authentication feature components.
    ///
    /// Handles user login, logout, and authentication flow management.
    var authAppFactory: AuthAppFactory { get }

    /// Factory for creating Account management components.
    ///
    /// Provides user account viewing, profile management, and account
    /// settings functionality.
    var accountAppFactory: AccountAppFactory { get }

    /// Factory for creating Account update service components.
    ///
    /// Handles account information updates, address changes, and profile
    /// synchronization across the application.
    var accountUpdateAppFactory: AccountUpdateAppFactory { get }

    /// Factory for creating Sidebar navigation components.
    ///
    /// Provides the main application navigation sidebar with feature
    /// selection and routing capabilities.
    var sidebarAppFactory: SidebarAppFactory { get }

    /// Factory for creating PURLs (Permanent URLs) feature components.
    ///
    /// Handles creation, management, and sharing of permanent redirect URLs.
    var purlsAppFactory: PURLsAppFactory { get }

    /// Factory for creating "Now page" feature components.
    ///
    /// Provides editing and management of the user's "now" status page content.
    var nowAppFactory: NowAppFactory { get }

    /// Factory for creating Web page editing components.
    ///
    /// Handles creation and editing of web pages hosted on the OMG platform.
    var webpageAppFactory: WebpageAppFactory { get }

    /// Factory for creating Pastebin feature components.
    ///
    /// Provides text paste creation, editing, sharing, and management functionality.
    var pastebinAppFactory: PastebinAppFactory { get }

    /// Factory for creating Weblog feature components.
    ///
    /// Handles blog post creation, editing, and weblog management functionality.
    var weblogAppFactory: WeblogAppFactory { get }

    /// Factory for creating Pics feature components.
    ///
    /// Provides image hosting, sharing, and management functionality
    /// on the some.pics subdomain platform.
    var picsAppFactory: PicsAppFactory { get }
}

struct TritonEnvironment: TritonEnvironmentProtocol {

    // MARK: - Properties

    var authSessionService: any AuthSessionServiceProtocol { container.resolve() }
    var sessionService: any SessionServiceProtocol { container.resolve() }
    var networkClient: any NetworkClientProtocol { container.resolve() }
    var shortcutsService: any ShortcutsServiceProtocol { container.resolve() }
    var clipboardService: any ClipboardServiceProtocol { container.resolve() }
    var statusAppFactory: StatusAppFactory { container.resolve() }
    var authAppFactory: AuthAppFactory { container.resolve() }
    var accountAppFactory: AccountAppFactory { container.resolve() }
    var accountUpdateAppFactory: AccountUpdateAppFactory { container.resolve() }
    var sidebarAppFactory: SidebarAppFactory { container.resolve() }
    var purlsAppFactory: PURLsAppFactory { container.resolve() }
    var nowAppFactory: NowAppFactory { container.resolve() }
    var webpageAppFactory: WebpageAppFactory { container.resolve() }
    var pastebinAppFactory: PastebinAppFactory { container.resolve() }
    var weblogAppFactory: WeblogAppFactory { container.resolve() }
    var picsAppFactory: PicsAppFactory { container.resolve() }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init() {
        self.init(
            authSessionServiceFactory: AuthSessionServiceFactory(),
            sessionServiceFactory: SessionServiceFactory(),
            networkClient: OMGAPIFactory(),
            shortcutsServiceFactory: ShortcutsServiceFactory(),
            clipboardServiceFactory: ClipboardServiceFactory()
        )
    }

    init(
        authSessionServiceFactory: any AuthSessionServiceFactoryProtocol,
        sessionServiceFactory: any SessionServiceFactoryProtocol,
        networkClient: any OMGAPIFactoryProtocol,
        shortcutsServiceFactory: any ShortcutsServiceFactoryProtocol,
        clipboardServiceFactory: any ClipboardServiceFactoryProtocol
    ) {
        container.register(
            type: (any AuthSessionServiceProtocol).self,
            allocation: .static
        ) { _ in
            authSessionServiceFactory.makeAuthSessionService()
        }

        container.register(
            type: (any SessionServiceProtocol).self,
            allocation: .static
        ) { _ in
            sessionServiceFactory.makeSessionService()
        }

        container.register(
            type: (any NetworkClientProtocol).self,
            allocation: .static
        ) { container in
            let authSessionService = container.resolve() as any AuthSessionServiceProtocol
            return networkClient.makeOMGAPIClient(
                authTokenProvider: {
                    await authSessionService.accessToken
                }
            )
        }

        container.register(
            type: (any ShortcutsServiceProtocol).self,
            allocation: .static
        ) { _ in
            shortcutsServiceFactory.makeShortcutsService()
        }

        container.register(
            type: (any ClipboardServiceProtocol).self,
            allocation: .static
        ) { _ in
            clipboardServiceFactory.makeClipboardService()
        }

        container.register(
            type: StatusAppFactory.self,
            allocation: .static
        ) { container in
            StatusAppFactory(
                sessionService: container.resolve(),
                authSessionService: container.resolve(),
                networkClient: container.resolve(),
                clipboardService: container.resolve()
            )
        }

        container.register(
            type: AuthAppFactory.self,
            allocation: .static
        ) { container in
            AuthAppFactory(
                authSessionService: container.resolve(),
                networkClient: container.resolve()
            )
        }

        container.register(
            type: AccountAppFactory.self,
            allocation: .static
        ) { container in
            AccountAppFactory(
                sessionService: container.resolve()
            )
        }

        container.register(
            type: AccountUpdateAppFactory.self,
            allocation: .static
        ) { container in
            AccountUpdateAppFactory(
                sessionService: container.resolve(),
                authSessionService: container.resolve(),
                networkClient: container.resolve()
            )
        }

        container.register(
            type: SidebarAppFactory.self,
            allocation: .static
        ) { container in
            SidebarAppFactory(
                authSessionService: container.resolve()
            )
        }

        container.register(
            type: PURLsAppFactory.self,
            allocation: .static
        ) { container in
            PURLsAppFactory(
                networkClient: container.resolve(),
                authSessionService: container.resolve(),
                sessionService: container.resolve(),
                clipboardService: container.resolve()
            )
        }

        container.register(
            type: NowAppFactory.self,
            allocation: .static
        ) { container in
            NowAppFactory(
                networkClient: container.resolve(),
                authSessionService: container.resolve(),
                sessionService: container.resolve()
            )
        }

        container.register(
            type: WebpageAppFactory.self,
            allocation: .static
        ) { container in
            WebpageAppFactory(
                networkClient: container.resolve(),
                authSessionService: container.resolve(),
                sessionService: container.resolve()
            )
        }

        container.register(
            type: PastebinAppFactory.self,
            allocation: .static
        ) { container in
            PastebinAppFactory(
                networkClient: container.resolve(),
                authSessionService: container.resolve(),
                sessionService: container.resolve(),
                clipboardService: container.resolve()
            )
        }

        container.register(
            type: WeblogAppFactory.self,
            allocation: .static
        ) { container in
            WeblogAppFactory(
                networkClient: container.resolve(),
                authSessionService: container.resolve(),
                sessionService: container.resolve(),
                clipboardService: container.resolve()
            )
        }

        container.register(
            type: PicsAppFactory.self,
            allocation: .static
        ) { container in
            PicsAppFactory(
                networkClient: container.resolve(),
                authSessionService: container.resolve(),
                sessionService: container.resolve(),
                clipboardService: container.resolve()
            )
        }
    }
}

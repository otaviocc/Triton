import Foundation

/// Enumeration of available features in the application.
///
/// `RouteFeature` represents the different functional areas of the OMG application
/// that can be navigated to or accessed through routing.
public enum RouteFeature: Codable {

    /// Status updates and timeline feature.
    case statuslog

    /// Permanent URL (PURL) management feature.
    case purls

    /// Webpage editing and management feature.
    case webpage

    /// "Now page" content management feature.
    case nowPage

    /// Weblog entries and blogging feature.
    case weblog

    /// Picture hosting and sharing feature (some.pics).
    case somePics

    /// Pastebin for sharing code and text snippets.
    case pastebin

    /// User account management and settings.
    case account

    /// Authentication and login/logout flows.
    case auth
}

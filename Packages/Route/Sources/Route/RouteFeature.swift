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

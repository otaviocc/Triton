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

/// A response model representing a status update fetched from the network.
///
/// This model serves as the data transfer object between the network layer and client code
/// for status timeline operations. It contains all the essential information about a status
/// update from the social timeline, transformed from the raw API response into a client-friendly format.
///
/// Status updates are social posts that include an emoji icon, markdown content, and metadata
/// about the author and publication time. They form the basis of the social timeline feature
/// where users can view updates from others in their network.
///
/// The model conforms to `Identifiable` for use in SwiftUI lists and collections,
/// `Equatable` for value comparison, and `Sendable` for safe concurrent usage.
public struct StatusResponse: Identifiable, Equatable, Sendable {

    /// The unique identifier of the status update.
    ///
    /// This identifier is used for referencing specific status updates across the system
    /// and is guaranteed to be unique within the statuslog service. It enables operations
    /// like replies, references, or deduplication of status updates.
    public let id: String

    /// The address of the user who posted the status update.
    ///
    /// This represents the user's address/domain within the OMG network and is used
    /// to identify the author of the status update. It enables attribution and
    /// potential user profile navigation.
    public let address: String

    /// The publication timestamp of the status update as a string.
    ///
    /// This represents when the status update was published and is provided as a
    /// string format from the API. It's used for chronological display and sorting
    /// of status updates in the timeline.
    public let timestamp: String

    /// The emoji icon associated with the status update.
    ///
    /// Every status update includes an emoji that provides visual context and emotional
    /// expression for the status. This emoji is displayed prominently alongside the
    /// status content to give users a quick visual indication of the status mood or type.
    public let emojiIcon: String

    /// The main content of the status update in markdown format.
    ///
    /// This contains the text content of the status update, which may include
    /// markdown formatting for rich text display. The content represents the
    /// user's message or update that they wanted to share with their network.
    public let markdownContent: String

    /// An optional external URL for replying to or interacting with the status.
    ///
    /// This URL provides a way to reply to or interact with the status update
    /// outside of the current application, typically linking to a web interface
    /// or external service where the status can be discussed or responded to.
    public let externalURL: URL?
}

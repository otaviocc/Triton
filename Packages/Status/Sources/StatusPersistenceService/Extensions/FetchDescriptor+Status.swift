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
import SwiftData

public extension FetchDescriptor where T == Status {

    // MARK: - Nested types

    /// Filter options for status date ranges.
    ///
    /// This enum provides temporal filtering options for status updates,
    /// allowing the UI to display statuses within specific time periods.
    enum DateFilter {

        case all
        case today
        case thisWeek
        case thisMonth
    }

    // MARK: - Public

    /// Creates the default fetch descriptor sorted by timestamp (newest first).
    ///
    /// This is the standard descriptor for displaying status updates in
    /// chronological order with the most recent statuses appearing first.
    ///
    /// - Returns: A `FetchDescriptor<Status>` configured for timestamp-descending sort.
    static func makeDefault() -> FetchDescriptor<Status> {
        .init(sortBy: [.init(\.timestamp, order: .reverse)])
    }

    /// Creates a filtered fetch descriptor for date-based filtering.
    ///
    /// This method creates a descriptor that filters status updates based on
    /// temporal ranges (today, this week, this month, or all time). The filtering
    /// uses calendar-based date ranges to ensure accurate boundary calculations.
    ///
    /// - Parameter filter: The date filter to apply to the status results.
    /// - Returns: A `FetchDescriptor<Status>` configured with the specified date filter.
    static func makeFiltered(by filter: DateFilter) -> FetchDescriptor<Status> {
        var descriptor = makeDefault()

        let calendar = Calendar.current
        let now = Date()

        let timestampRange: (start: TimeInterval, end: TimeInterval)?
        switch filter {
        case .all:
            timestampRange = nil

        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            if let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) {
                timestampRange = (startOfDay.timeIntervalSince1970, endOfDay.timeIntervalSince1970)
            } else {
                timestampRange = nil
            }

        case .thisWeek:
            if let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start,
               let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)
            {
                timestampRange = (startOfWeek.timeIntervalSince1970, endOfWeek.timeIntervalSince1970)
            } else {
                timestampRange = nil
            }

        case .thisMonth:
            if let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start,
               let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)
            {
                timestampRange = (startOfMonth.timeIntervalSince1970, endOfMonth.timeIntervalSince1970)
            } else {
                timestampRange = nil
            }
        }

        if let range = timestampRange {
            let startTimestamp = range.start
            let endTimestamp = range.end
            descriptor.predicate = #Predicate<Status> { status in
                status.timestamp >= startTimestamp && status.timestamp < endTimestamp
            }
        }

        return descriptor
    }
}

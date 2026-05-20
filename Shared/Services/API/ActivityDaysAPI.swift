//
//  ActivityDaysAPI.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

public class ActivityDaysAPI {
    private let client: FoundationClient

    public init(client: FoundationClient) {
        self.client = client
    }

    // MARK: - GET /v1/activity-days
    public func getActivityDays(
        from: String? = nil,
        to: String? = nil,
        type: String? = "QURAN",
        first: Int? = nil,
        after: String? = nil
    ) -> AnyPublisher<ActivityDaysResponse, Error> {
        var queryItems: [URLQueryItem] = []
        if let from  = from  { queryItems.append(.init(name: "from",  value: from)) }
        if let to    = to    { queryItems.append(.init(name: "to",    value: to)) }
        if let type  = type  { queryItems.append(.init(name: "type",  value: type)) }
        if let first = first { queryItems.append(.init(name: "first", value: String(first))) }
        if let after = after { queryItems.append(.init(name: "after", value: after)) }

        return client.request(
            FoundationEndpoints.activityDays,
            method: .get,
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
    }

    // MARK: - POST /v1/activity-days
    /// `ranges` must be a JSON array of strings, e.g. ["1:1-1:7", "2:255-2:255"].
    public func addActivityDay(
        type: String,
        seconds: Int,
        ranges: [String],
        mushafId: Int,
        date: String? = nil,
        timezone: String? = nil
    ) -> AnyPublisher<ActivityDayPostResponse, Error> {
        var body: [String: Any] = [
            "type":     type,
            "seconds":  seconds,
            "ranges":   ranges,   // Array — the API requires a JSON array, not a CSV string
            "mushafId": mushafId
        ]
        if let date = date { body["date"] = date }

        guard let data = try? JSONSerialization.data(withJSONObject: body) else {
            return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
        }

        let tz = timezone ?? TimeZone.current.identifier
        return client.request(
            FoundationEndpoints.activityDays,
            method: .post,
            body: data,
            additionalHeaders: ["x-timezone": tz]
        )
    }

    // MARK: - GET /v1/activity-days/estimate-reading-time
    public func estimateReadingTime(ranges: String) -> AnyPublisher<ActivityDayEstimateResponse, Error> {
        let queryItems = [URLQueryItem(name: "ranges", value: ranges)]
        return client.request(
            FoundationEndpoints.activityDaysEstimateReadingTime,
            method: .get,
            queryItems: queryItems
        )
    }
}

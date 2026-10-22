//
//  TimerActivityAttributes.swift
//  Timer
//
//  Created by Lívia Lima Bion on 21/10/26.
//

import Foundation
import ActivityKit

nonisolated struct TimerActivityAttributes: ActivityAttributes {
    nonisolated struct ContentState: Codable, Hashable {
        let accumulatedTime: TimeInterval
        let startedAt: Date?
        let isRunning: Bool
    }

    let name: String
}

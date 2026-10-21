import Foundation

struct StopwatchState: Codable, Hashable {
    private(set) var accumulatedTime: TimeInterval = 0
    private(set) var startedAt: Date?

    var isRunning: Bool {
        startedAt != nil
    }

    func elapsedTime(at date: Date) -> TimeInterval {
        guard let startedAt else {
            return accumulatedTime
        }

        return accumulatedTime + max(0, date.timeIntervalSince(startedAt))
    }

    mutating func toggle(at date: Date) {
        if isRunning {
            pause(at: date)
        } else {
            start(at: date)
        }
    }

    mutating func start(at date: Date) {
        guard !isRunning else {
            return
        }

        startedAt = date
    }

    mutating func pause(at date: Date) {
        guard isRunning else {
            return
        }

        accumulatedTime = elapsedTime(at: date)
        startedAt = nil
    }

    mutating func reset() {
        accumulatedTime = 0
        startedAt = nil
    }
}

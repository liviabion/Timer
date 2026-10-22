import ActivityKit
import Foundation

@MainActor
final class TimerLiveActivityManager {
    private var activity: Activity<TimerActivityAttributes>? =
        Activity<TimerActivityAttributes>.activities.first

    func start(with stopwatch: StopwatchState) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return
        }

        guard activity == nil else {
            return
        }

        let attributes = TimerActivityAttributes(
            name: "Meu cronômetro"
        )

        let content = ActivityContent(
            state: makeContentState(from: stopwatch),
            staleDate: nil
        )

        do {
            activity = try Activity.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Erro ao iniciar Live Activity: \(error)")
        }
    }

    func startOrResume(with stopwatch: StopwatchState) async {
        if resolveActivity() == nil {
            start(with: stopwatch)
        } else {
            await update(with: stopwatch)
        }
    }

    func update(with stopwatch: StopwatchState) async {
        guard let activity = resolveActivity() else {
            return
        }

        await activity.update(
            ActivityContent(
                state: makeContentState(from: stopwatch),
                staleDate: nil
            )
        )
    }

    func end(with stopwatch: StopwatchState) async {
        guard let activity = resolveActivity() else {
            return
        }

        await activity.end(
            ActivityContent(
                state: makeContentState(from: stopwatch),
                staleDate: nil
            ),
            dismissalPolicy: .immediate
        )

        self.activity = nil
    }

    private func resolveActivity()
        -> Activity<TimerActivityAttributes>? {
        if let activity, activity.activityState == .active {
            return activity
        }

        activity =
            Activity<TimerActivityAttributes>.activities.first

        return activity
    }

    private func makeContentState(
        from stopwatch: StopwatchState
    ) -> TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(
            accumulatedTime: stopwatch.accumulatedTime,
            startedAt: stopwatch.startedAt,
            isRunning: stopwatch.isRunning
        )
    }
}

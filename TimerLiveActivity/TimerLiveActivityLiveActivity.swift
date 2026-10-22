//
//  TimerLiveActivityLiveActivity.swift
//  TimerLiveActivity
//
//  Created by Lívia Lima Bion on 21/10/26.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TimerLiveActivityView: View {
    let attributes: TimerActivityAttributes
    let state: TimerActivityAttributes.ContentState

    var body: some View {
        VStack(spacing: 8) {
            Text(attributes.name)
                .font(.headline)

            elapsedTime
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)

            Text(state.isRunning ? "Em andamento" : "Pausado")
                .font(.caption)
        }
        .padding()
        .foregroundStyle(.black)
    }

    @ViewBuilder
    private var elapsedTime: some View {
        if state.isRunning, let startedAt = state.startedAt {
            let referenceDate = startedAt.addingTimeInterval(
                -state.accumulatedTime
            )

            Text(
                timerInterval: referenceDate...Date.distantFuture,
                countsDown: false,
                showsHours: true
            )
            .font(.title)
            .monospacedDigit()
        } else {
            Text(
                Duration.seconds(state.accumulatedTime),
                format: .time(
                    pattern: .hourMinuteSecond(padHourToLength: 2)
                )
            )
            .font(.title)
            .monospacedDigit()
        }
    }
}

struct TimerLiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            TimerLiveActivityView(
                attributes: context.attributes,
                state: context.state
            )
            .activityBackgroundTint(.white)
            .activitySystemActionForegroundColor(.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    TimerLiveActivityView(
                        attributes: context.attributes,
                        state: context.state
                    )
                }
            } compactLeading: {
                Image(systemName: "stopwatch")
            } compactTrailing: {
                Text(context.state.isRunning ? "Ativo" : "Pausa")
                    .font(.caption2)
            } minimal: {
                Image(systemName: "stopwatch")
            }
            .keylineTint(.primary)
        }
    }
}

extension TimerActivityAttributes {
    fileprivate static var preview: TimerActivityAttributes {
        TimerActivityAttributes(name: "Meu cronômetro")
    }
}

extension TimerActivityAttributes.ContentState {
    fileprivate static var running: TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(
            accumulatedTime: 30,
            startedAt: .now,
            isRunning: true
        )
    }

    fileprivate static var paused: TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(
            accumulatedTime: 90,
            startedAt: nil,
            isRunning: false
        )
    }
}

#Preview(
    "Tela Bloqueada",
    as: .content,
    using: TimerActivityAttributes.preview
) {
    TimerLiveActivityLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.running
    TimerActivityAttributes.ContentState.paused
}

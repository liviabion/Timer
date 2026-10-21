import Foundation
import SwiftUI

struct ContentView: View {
    @State private var stopwatch = StopwatchState()

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Cronômetro")
                .font(.largeTitle)

            TimelineView(
                .animation(
                    minimumInterval: 0.01,
                    paused: !stopwatch.isRunning
                )
            ) { context in
                Text(formattedTime(at: context.date))
                    .font(.system(size: 60, design: .monospaced))
                    .monospacedDigit()
            }

            HStack {
                Button("Iniciar") {
                    stopwatch.start(at: .now)
                }
                .buttonStyle(.borderedProminent)
                .disabled(stopwatch.isRunning)

                Button("Pausar") {
                    stopwatch.pause(at: .now)
                }
                .buttonStyle(.bordered)
                .disabled(!stopwatch.isRunning)

                Button("Encerrar", role: .destructive) {
                    stopwatch.reset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }

    private func formattedTime(at date: Date) -> String {
        let elapsedTime = stopwatch.elapsedTime(at: date)
        let totalHundredths = Int64(elapsedTime * 100)
        let minutes = totalHundredths / 6_000
        let seconds = totalHundredths / 100 % 60
        let hundredths = totalHundredths % 100

        return String(
            format: "%02d:%02d.%02d",
            Int(minutes),
            Int(seconds),
            Int(hundredths)
        )
    }
}

#Preview {
    ContentView()
}

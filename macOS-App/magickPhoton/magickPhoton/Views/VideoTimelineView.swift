import SwiftUI
import AVKit

struct VideoTimelineView: View {
    @State private var videoURL: URL
    @Binding var startTime: Double
    @Binding var endTime: Double

    @State private var player: AVPlayer?
    @State private var currentTime: CMTime = .zero
    @State private var duration: CMTime = .zero
    @State private var isPlaying = false

    init(videoURL: URL, startTime: Binding<Double>, endTime: Binding<Double>) {
        self._videoURL = State(initialValue: videoURL)
        self._startTime = startTime
        self._endTime = endTime

        // Fixed: Using AVURLAsset(url:) instead of deprecated init(url:)
        let asset = AVURLAsset(url: videoURL)
        self.duration = asset.duration
    }

    var body: some View {
        VStack(spacing: 0) {
            // Timeline controls and visualization
            HStack {
                Text("Start: \(timeString(time: startTime))")
                    .font(.caption)

                Slider(value: $startTime, in: 0...endTime, step: 0.1)
                    .frame(height: 20)

                Text("End: \(timeString(time: endTime))")
                    .font(.caption)
            }
            .padding(.horizontal)

            // Timeline preview
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))

                    // Start marker
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 2)
                        .offset(x: geometry.size.width * CGFloat(startTime / duration.seconds))

                    // End marker
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 2)
                        .offset(x: geometry.size.width * CGFloat(endTime / duration.seconds))
                }
            }
            .frame(height: 30)
        }
    }

    private func timeString(time: Double) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time / 60) % 60
        let hours = Int(time / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    VideoTimelineView(videoURL: URL(fileURLWithPath: ""), startTime: .constant(0), endTime: .constant(10))
}
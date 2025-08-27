
import SwiftUI
import AVKit

struct VideoTimelineView: View {
    var videoURL: URL
    @Binding var startTime: Double
    @Binding var endTime: Double
    @State private var duration: Double = 0
    
    var body: some View {
        VStack {
            Text("Video Timeline")
                .font(.headline)
            
            HStack {
                Text(timeString(time: startTime))
                Slider(value: $startTime, in: 0...endTime, step: 0.1) {
                    Text("Start Time")
                }
            }
            
            HStack {
                Text(timeString(time: endTime))
                Slider(value: $endTime, in: startTime...duration, step: 0.1) {
                    Text("End Time")
                }
            }
            
            Text("Duration: \(timeString(time: duration))")
                .font(.caption)
        }
        .onAppear {
            loadDuration()
        }
    }
    
    private func timeString(time: Double) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time / 60) % 60
        let hours = Int(time / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func loadDuration() {
        let asset = AVAsset(url: videoURL)
        Task {
            do {
                let duration = try await asset.load(.duration)
                self.duration = duration.seconds
                if endTime > duration {
                    endTime = duration
                }
            } catch {
                print("Error loading video duration: \(error)")
            }
        }
    }
}


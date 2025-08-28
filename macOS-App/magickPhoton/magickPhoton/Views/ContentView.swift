import SwiftUI
import AVKit
import Combine

struct ContentView: View {
    @State private var inputURL: URL? = nil
    @State private var player: AVPlayer? = nil
    @State private var isCropActive = false
    @State private var srModel = "eugenesiow/sr-div2k"
    @State private var startTime: Double = 0
    @State private var endTime: Double = 10
    @State private var cropRect = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
    @State private var isProcessing = false
    @State private var processingResult: String? = nil

    // Add an observer for the notification
    @State private var serviceFileCancellable: AnyCancellable?

    var body: some View {
        HStack(spacing: 0) {
            // Left Panel - File Browser and Controls
            VStack(spacing: 0) {
                FileBrowserView(selectedFile: $inputURL)
                    .frame(height: 200)

                ControlPanelView(
                    isCropActive: $isCropActive,
                    srModel: $srModel,
                    startTime: $startTime,
                    endTime: $endTime,
                )
                .frame(maxHeight: .infinity)
            }
            .frame(width: 300)
            .background(Color(NSColor.windowBackgroundColor))

            // Main Content Area - Preview and Timeline
            VStack(spacing: 0) {
                HStack {
                    PreviewPanel(
                        player: player,
                        isOriginal: true,
                        cropRect: $cropRect,
                        isActive: $isCropActive
                    )

                    PreviewPanel(
                        player: player,
                        isOriginal: false,
                        cropRect: $cropRect,
                        isActive: .constant(false)
                    )
                }

                VideoTimelineView(
                    videoURL: inputURL ?? URL(fileURLWithPath: ""),
                    startTime: $startTime,
                    endTime: $endTime
                )
                .frame(height: 150)
            }
        }
        .onAppear {
            setupServiceObserver()
            // Test Python environment
            if !PythonBridge.shared.testPythonEnvironment() {
                print("Warning: Python environment not properly configured")
            }
        }
        .onChange(of: inputURL) { newValue in
            if let url = newValue {
                player = AVPlayer(url: url)
            } else {
                player = nil
            }
        }
    }

    private func setupServiceObserver() {
        serviceFileCancellable = NotificationCenter.default.publisher(for: .serviceFileNotification)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error in service file observer: \(error)")
                    }
                },
                receiveValue: { notification in
                    if let filePath = notification.object as? String {
                        do {
                            let url = URL(fileURLWithPath: filePath)
                            self.inputURL = url
                        } catch {
                            print("Error creating URL from file path: \(error)")
                        }
                    }
                }
            )
    }

    private func processMedia() {
        guard let inputURL = inputURL else { return }

        isProcessing = true
        processingResult = "Processing media..."

        // Create output path
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("output.mp4")

        // Prepare operations dictionary
        var operations: [String: Any] = [:]

        if isCropActive {
            operations["crop"] = [Int(cropRect.minX * 100), Int(cropRect.minY * 100),
                                 Int(cropRect.width * 100), Int(cropRect.height * 100)]
        }

        if !srModel.isEmpty {
            operations["sr_model"] = srModel
        }

        // Add time cropping
        let start = timeString(time: startTime)
        let end = timeString(time: endTime)
        operations["time_crop"] = "\(start)-\(end)"

        // Use Python bridge to process media
        let result = PythonBridge.shared.processMedia(
            inputPath: inputURL.path,
            outputPath: outputPath.path,
            operations: operations
        )

        DispatchQueue.main.async {
            isProcessing = false
            if result {
                processingResult = "Processing completed successfully!"
                // Update the preview with output file
                self.player = AVPlayer(url: outputPath)
            } else {
                processingResult = "Processing failed. Check console for errors."
            }

            // Reset result message after a while
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.processingResult = nil
            }
        }
    }

    private func timeString(time: Double) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time / 60) % 60
        let hours = Int(time / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// Extension for the notification
extension Notification.Name {
    static let serviceFileNotification = Notification.Name("ServiceFileNotification")
}

#Preview {
    ContentView()
}

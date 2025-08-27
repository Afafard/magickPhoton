import SwiftUI
import AVKit
import Combine

struct ContentView: View {
    @State private var inputURL: URL? = nil
    @State private var isCropActive = false
    @State private var srModel = "eugenesiow/sr-div2k"
    @State private var startTime: Double = 0
    @State private var endTime: Double = 10
    @State private var cropRect = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
    @State private var isProcessing = false
    
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
                    endTime: $endTime
                )
                .frame(maxHeight: .infinity)
            }
            .frame(width: 300)
            .background(Color(NSColor.windowBackgroundColor))
            
            // Main Content Area - Preview and Timeline
            VStack(spacing: 0) {
                HStack {
                    PreviewPanel(
                        player: inputURL != nil ? AVPlayer(url: inputURL!) : nil,
                        isOriginal: true,
                        cropRect: $cropRect,
                        isActive: $isCropActive
                    )
                    
                    PreviewPanel(
                        player: inputURL != nil ? AVPlayer(url: inputURL!) : nil,
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
        }
    }
    
    private func setupServiceObserver() {
        serviceFileCancellable = NotificationCenter.default.publisher(for: .serviceFileNotification)
            .receive(on: DispatchQueue.main)
            .sink { notification in
                if let filePath = notification.object as? String {
                    self.inputURL = URL(fileURLWithPath: filePath)
                }
            }
    }
}

// Extension for the notification
extension Notification.Name {
    static let serviceFileNotification = Notification.Name("ServiceFileNotification")
}

#Preview {
    ContentView()
}

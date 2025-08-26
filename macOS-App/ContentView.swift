import SwiftUI
import AVKit

struct ContentView: View {
    @State private var inputURL: URL? = nil
    @State private var showSplitView = true
    @State private var cropRect = CGRect(x: 100, y: 100, width: 300, height: 300)
    @State private var isCropActive = false
    @State private var startTime: Double = 0
    @State private var endTime: Double = 60
    @State private var selectedSRModel = ""
    
    // Preview controllers
    @State private var originalPlayer: AVPlayer?
    @State private var processedPlayer: AVPlayer?
    
    var body: some View {
        NavigationView {
            // Left: File Browser
            FileBrowserView(selectedFile: $inputURL)
                .frame(width: 250)
            
            // Center: Preview
            VStack {
                Toggle("Split View", isOn: $showSplitView)
                    .padding()
                
                HStack(spacing: 20) {
                    if showSplitView {
                        PreviewPanel(player: originalPlayer, isOriginal: true, cropRect: $cropRect, isActive: $isCropActive)
                    }
                    PreviewPanel(player: processedPlayer, isOriginal: false, cropRect: $cropRect, isActive: $isCropActive)
                }
                
                if let duration = originalPlayer?.currentItem?.duration.seconds {
                    VideoTimelineView(
                        duration: duration,
                        startTime: $startTime,
                        endTime: $endTime
                    )
                    .padding()
                }
            }
            
            // Right: Controls
            ControlPanelView(
                isCropActive: $isCropActive,
                srModel: $selectedSRModel,
                startTime: $startTime,
                endTime: $endTime
            )
            .frame(width: 300)
        }
        .preferredColorScheme(.dark)
        .onChange(of: inputURL) { newURL in
            guard let url = newURL else { return }
            originalPlayer = AVPlayer(url: url)
            processedPlayer = AVPlayer(url: url)
        }
    }
}

struct PreviewPanel: View {
    var player: AVPlayer?
    var isOriginal: Bool
    @Binding var cropRect: CGRect
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .frame(height: 400)
            
            if isActive && isOriginal {
                CropOverlay(rect: $cropRect)
                    .allowsHitTesting(true)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
}

struct CropOverlay: View {
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Dimmed overlay
                Color.black.opacity(0.6)
                
                // Clear crop area
                Rectangle()
                    .path(in: CGRect(
                        x: rect.minX * geo.size.width,
                        y: rect.minY * geo.size.height,
                        width: rect.width * geo.size.width,
                        height: rect.height * geo.size.height
                    ))
                    .fill(Color.clear)
                    .border(Color.white, width: 2)
                
                // Resize handles
                ForEach(0..<4, id: \.self) { i in
                    Circle()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.blue)
                        .position(getHandlePosition(index: i, size: geo.size))
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Handle drag logic
                    }
            )
        }
    }
    
    private func getHandlePosition(index: Int, size: CGSize) -> CGPoint {
        let x = rect.minX * size.width + (index % 2 == 0 ? 0 : rect.width * size.width)
        let y = rect.minY * size.height + (index < 2 ? 0 : rect.height * size.height)
        return CGPoint(x: x, y: y)
    }
}


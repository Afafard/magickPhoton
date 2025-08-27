import SwiftUI
import AVKit

struct PreviewPanel: View {
    var player: AVPlayer?
    var isOriginal: Bool
    @Binding var cropRect: CGRect
    @Binding var isActive: Bool
    
    var body: some View {
        VStack {
            Text(isOriginal ? "Original" : "Processed")
                .font(.headline)
                .padding(.top)
            
            ZStack {
                if let player = player {
                    VideoPlayer(player: player)
                        .frame(height: 400)
                } else {
                    Text("No media selected")
                        .frame(width: 400, height: 400)
                        .background(Color.gray)
                }
                
                if isActive && isOriginal {
                    CropOverlay(rect: $cropRect)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 2)
            )
        }
        .padding()
    }
}


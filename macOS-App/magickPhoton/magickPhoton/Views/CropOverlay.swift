import SwiftUI

struct CropOverlay: View {
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dimmed overlay
                Color.black.opacity(0.6)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Clear crop area
                Rectangle()
                    .path(in: CGRect(
                        x: rect.minX * geometry.size.width,
                        y: rect.minY * geometry.size.height,
                        width: rect.width * geometry.size.width,
                        height: rect.height * geometry.size.height
                    ))
                    .fill(Color.clear)
                    .border(Color.white, width: 2)
                
                // Resize handles
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.blue)
                        .position(
                            x: positionForHandle(index: index, in: rect, width: geometry.size.width),
                            y: positionForHandle(index: index, in: rect, height: geometry.size.height)
                        )
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Handle drag logic for crop area adjustment
                        adjustCropRect(location: value.location, in: geometry.size)
                    }
            )
        }
    }
    
    private func positionForHandle(index: Int, in rect: CGRect, width: CGFloat) -> CGFloat {
        switch index {
        case 0, 1: return rect.minX * width
        case 2, 3: return rect.maxX * width
        default: return 0
        }
    }
    
    private func positionForHandle(index: Int, in rect: CGRect, height: CGFloat) -> CGFloat {
        switch index {
        case 0, 2: return rect.minY * height
        case 1, 3: return rect.maxY * height
        default: return 0
        }
    }
    
    private func adjustCropRect(location: CGPoint, in size: CGSize) {
        // Calculate normalized coordinates
        let x = location.x / size.width
        let y = location.y / size.height
        
        // Update crop rectangle based on drag location
        // (Implementation would depend on which handle is being dragged)
        rect = CGRect(x: x - 0.1, y: y - 0.1, width: 0.2, height: 0.2)
    }
}


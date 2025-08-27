import SwiftUI
import UniformTypeIdentifiers

struct FileBrowserView: View {
    @Binding var selectedFile: URL?
    
    var body: some View {
        VStack {
            Text("Media Browser")
                .font(.headline)
                .padding()
            
            Button("Select File") {
                let panel = NSOpenPanel()
                panel.allowedContentTypes = [
                    UTType.image, 
                    UTType.movie,
                    UTType.audiovisualContent
                ]
                panel.allowsMultipleSelection = false
                
                if panel.runModal() == .OK {
                    selectedFile = panel.url
                }
            }
            .padding()
            
            if let file = selectedFile {
                Text("Selected: \(file.lastPathComponent)")
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding()
            }
            
            Spacer()
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}


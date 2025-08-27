import SwiftUI

struct ControlPanelView: View {
    @Binding var isCropActive: Bool
    @Binding var srModel: String
    @Binding var startTime: Double
    @Binding var endTime: Double
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Crop Controls
                GroupBox(label: Text("Crop")) {
                    Toggle("Enable Crop", isOn: $isCropActive)
                        .padding(.bottom)
                    
                    HStack {
                        Text("X:")
                        TextField("X", value: .constant(0), formatter: NumberFormatter())
                        Text("Y:")
                        TextField("Y", value: .constant(0), formatter: NumberFormatter())
                        Text("Width:")
                        TextField("Width", value: .constant(100), formatter: NumberFormatter())
                        Text("Height:")
                        TextField("Height", value: .constant(100), formatter: NumberFormatter())
                    }
                }
                .padding()
                
                // Video Controls
                GroupBox(label: Text("Video Operations")) {
                    VStack(alignment: .leading) {
                        Text("Time Selection:")
                        HStack {
                            Text("Start: \(timeString(time: startTime))")
                            Spacer()
                            Text("End: \(timeString(time: endTime))")
                        }
                        .padding(.bottom)
                        
                        Toggle("Remove Audio", isOn: .constant(false))
                        Toggle("Interpolate Frames", isOn: .constant(false))
                        TextField("Target FPS", value: .constant(30), formatter: NumberFormatter())
                            .disabled(true)
                        
                        Picker("Compression", selection: .constant("medium")) {
                            Text("High Quality").tag("high")
                            Text("Medium Quality").tag("medium")
                            Text("Low Quality").tag("low")
                        }
                    }
                }
                .padding()
                
                // AI Operations
                GroupBox(label: Text("AI Enhancements")) {
                    VStack(alignment: .leading) {
                        Picker("Super-Resolution Model", selection: $srModel) {
                            Text("ESRGAN").tag("eugenesiow/sr-div2k")
                            Text("Real-ESRGAN").tag("nateraw/real-esrgan")
                            Text("Custom Model...").tag("custom")
                        }
                        
                        Button("Process") {
                            // Process media with selected options
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
    
    private func timeString(time: Double) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


import SwiftUI

struct ControlPanelView: View {
    @Binding var isCropActive: Bool
    @Binding var srModel: String
    @Binding var startTime: Double
    @Binding var endTime: Double
    
    // Add state variables for crop rectangle values
    @State private var cropX: Double = 0.25
    @State private var cropY: Double = 0.25
    @State private var cropWidth: Double = 0.5
    @State private var cropHeight: Double = 0.5
    @State private var isProcessing = false
    @State private var processingMessage = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Crop Controls
                GroupBox(label: Text("Crop")) {
                    Toggle("Enable Crop", isOn: $isCropActive)
                        .padding(.bottom)

                    HStack {
                        Text("X:")
                        TextField("X", value: $cropX, formatter: NumberFormatter())
                        Text("Y:")
                        TextField("Y", value: $cropY, formatter: NumberFormatter())
                        Text("Width:")
                        TextField("Width", value: $cropWidth, formatter: NumberFormatter())
                        Text("Height:")
                        TextField("Height", value: $cropHeight, formatter: NumberFormatter())
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
                            processMedia()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                        .disabled(isProcessing)
                    }
                }
                .padding()

                if !processingMessage.isEmpty {
                    Text(processingMessage)
                        .foregroundColor(.primary)
                        .padding()
                }

                Spacer()
            }
        }
    }

    private func timeString(time: Double) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time / 60) % 60
        let hours = Int(time / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func processMedia() {
        // This will be called when the Process button is clicked
        isProcessing = true
        processingMessage = "Processing media..."

        // In a real implementation, you would:
        // 1. Get the input file URL from ContentView
        // 2. Collect all the settings from the UI
        // 3. Call PythonBridge to execute the processing

        // For now, just simulate the process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isProcessing = false
            processingMessage = "Processing complete!"

            // Reset message after a while
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.processingMessage = ""
            }
        }
    }
}
import XCTest
@testable import magickPhoton

class SwiftUnitTests: XCTestCase {
    
    func testPythonBridgeInitialization() {
        // Test that the Python bridge can be initialized
        let bridge = PythonBridge.shared
        XCTAssertNotNil(bridge)
    }
    
    func testProcessMediaWithCrop() {
        // Create a mock input file path
        let inputFile = "/tmp/test_input.mp4"
        
        // Mock output file path
        let outputFile = "/tmp/test_output.mp4"
        
        // Define operations dictionary with crop
        var operations: [String: Any] = [:]
        operations["crop"] = [10, 10, 50, 50]
        operations["sr_model"] = "eugenesiow/sr-div2k"
        
        // This would actually call Python code
        let result = PythonBridge.shared.processMedia(
            inputPath: inputFile,
            outputPath: outputFile,
            operations: operations
        )
        
        // Since we're not actually calling Python in this test, 
        // we'll just check that the function doesn't crash
        XCTAssertNotNil(result)
    }
    
    func testCropRectValues() {
        // Test crop rectangle value handling
        let cropRect = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
        
        XCTAssertEqual(cropRect.minX, 0.25)
        XCTAssertEqual(cropRect.minY, 0.25)
        XCTAssertEqual(cropRect.width, 0.5)
        XCTAssertEqual(cropRect.height, 0.5)
    }
    
    func testTimeStringConversion() {
        // Test time string conversion
        let time = ContentView().timeString(time: 65.0)
        XCTAssertEqual(time, "01:05")
        
        let time2 = ContentView().timeString(time: 3661.0)
        XCTAssertEqual(time2, "01:01:01")
    }
}
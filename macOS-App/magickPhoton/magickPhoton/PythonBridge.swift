import Foundation

class PythonBridge {
    static let shared = PythonBridge()

    private init() {}

    func runPythonScript(scriptName: String, arguments: [String] = []) -> String? {
        // Build the command to execute Python script
        let pythonExecutable = "/usr/bin/python3"

        // Get the path of the main Python script in the bundle
        guard let scriptPath = Bundle.main.path(forResource: "main", ofType: "py") else {
            print("Could not find main.py in bundle")
            return nil
        }

        var command = [pythonExecutable, scriptPath]
        command.append(contentsOf: arguments)

        // Execute the command
        let task = Process()
        task.executableURL = URL(fileURLWithPath: pythonExecutable)
        task.arguments = [scriptPath] + arguments

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        do {
            try task.run()
            task.waitUntilExit()

            if task.terminationStatus == 0 {
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                return String(data: data, encoding: .utf8)
            } else {
                print("Python script failed with exit code: \(task.terminationStatus)")
                let errorData = pipe.fileHandleForReading.readDataToEndOfFile()
                if let errorString = String(data: errorData, encoding: .utf8) {
                    print("Error output: \(errorString)")
                }
                return nil
            }
        } catch {
            print("Error executing Python script: \(error)")
            return nil
        }
    }

    func processMedia(inputPath: String, outputPath: String, operations: [String: Any]) -> Bool {
        // Convert operations to arguments for Python CLI
        var args = ["--input", inputPath, "--output", outputPath]

        if let crop = operations["crop"] as? [Int] {
            args.append("--crop")
            args.append(String(crop[0]))
            args.append(String(crop[1]))
            args.append(String(crop[2]))
            args.append(String(crop[3]))
        }

        if let srModel = operations["sr_model"] as? String {
            args.append("--sr_model")
            args.append(srModel)
        }

        // Add more operation handling as needed
        if let timeCrop = operations["time_crop"] as? String {
            args.append("--time_crop")
            args.append(timeCrop)
        }

        print("Executing Python command with arguments: \(args)")

        // Run the actual Python script
        let result = runPythonScript(scriptName: "main", arguments: args)

        if let output = result {
            print("Python script output: \(output)")
            return true
        } else {
            print("Python script failed")
            return false
        }
    }

    func testPythonEnvironment() -> Bool {
        // Test that Python environment is working
        guard let pythonPath = Bundle.main.path(forResource: "main", ofType: "py") else {
            return false
        }

        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/python3")
        task.arguments = ["-c", "import sys; print('Python is working'); sys.exit(0)"]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        do {
            try task.run()
            task.waitUntilExit()

            return task.terminationStatus == 0
        } catch {
            print("Error testing Python environment: \(error)")
            return false
        }
    }
}

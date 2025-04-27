import Foundation
import SwiftUI

@MainActor
public class BasicLogger: ObservableObject {
    public static let shared = BasicLogger()
    
    @Published private(set) var logs: [String] = []
    
    private let fileURL: URL
    
    private init() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = directory.appendingPathComponent("log.txt")
        print(fileURL.absoluteString)
        loadLogs()
    }
    
    public func log(_ message: String) {
        print(message)
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let entry = "[\(timestamp)] \(message)"
        
        logs.append(entry)
        saveLogEntry(entry)
    }
    
    private func loadLogs() {
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            logs = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        } catch {
            print("Failed to load logs: \(error.localizedDescription)")
            logs = []
        }
    }
    
    private func saveLogEntry(_ entry: String) {
        do {
            let data = (entry + "\n").data(using: .utf8)!
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                try fileHandle.seekToEnd()
                try fileHandle.write(contentsOf: data)
                try fileHandle.close()
            } else {
                try data.write(to: fileURL)
            }
        } catch {
            print("Failed to save log entry: \(error.localizedDescription)")
        }
    }
    public func clear() {
        logs.removeAll()
        do {
            try "".write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to clear log file: \(error.localizedDescription)")
        }
    }
}

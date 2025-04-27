//
//  LogView.swift
//  BasicLogger
//
//  Created by Holger Krupp on 27.04.25.
//

import SwiftUI

public struct LogView: View {
    @StateObject private var logger = BasicLogger.shared
    @State private var searchText = ""

    public init() {}

    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(role: .destructive) {
                    logger.clear()
                } label: {
                    Label("Clear Logs", systemImage: "trash")
                        .font(.caption)
                }
                .padding()
            }
            
            List {
                ForEach(filteredLogs, id: \.self) { log in
                    Text(log)
                        .font(.system(.footnote, design: .monospaced))
                        .padding(.vertical, 2)
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Search logs")
        }
        .navigationTitle("Logs")
    }
    
    private var filteredLogs: [String] {
        if searchText.isEmpty {
            return logger.logs
        } else {
            return logger.logs.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

import Foundation



func cleanQuestionText(_ text: String) -> String {
    var cleanedText = text
        .replacingOccurrences(of: "\\n", with: "\n")
        .replacingOccurrences(of: "\\\"", with: "\"")
        .trimmingCharacters(in: .whitespacesAndNewlines)

    let unwantedPrefixes = ["Info", "Debug", "Error", "Successfully", "Starting agent"]
    for prefix in unwantedPrefixes {
        if cleanedText.starts(with: prefix) {
            return ""
        }
    }

    if cleanedText.hasPrefix("[") && cleanedText.hasSuffix("]") {
        cleanedText = String(cleanedText.dropFirst().dropLast())
    }

    return cleanedText
}

struct LogEntry: Codable {
    let log_entry: String
}

struct LogResponse: Codable {
    let logs: [LogEntry]
}

//
//  LogEntry.swift
//  InterView
//
//  Created by Hassan Alkhafaji on 2/2/25.
//


import Foundation

func fetchProcessedQuestions(completion: @escaping ([String]) -> Void) {
    let agentAddress = "agent1qwqpl4m8kzc7mskuax8xstwcw9xdskxgpd5fzhw67zcxefdhax5kvycjnz8"
    let urlString = "https://agentverse.ai/v1/hosting/agents/\(agentAddress)/logs/latest"
    
    guard let url = URL(string: urlString) else {
        print("❌ Invalid URL")
        completion([])
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Bearer eyJhbGciOiJSUzI1NiJ9.eyJleHAiOjE3NDEwNTk1OTIsImlhdCI6MTczODQ2NzU5MiwiaXNzIjoiZmV0Y2guYWkiLCJqdGkiOiIwNTBkMGJhYjM1MjUxNDU1ODhkNTMwZTQiLCJzY29wZSI6ImF2OnJvIiwic3ViIjoiODNlMTY5MzBiM2FlMzA5Y2M0YzcwNGE5NDY3MDgwNjY1MjY0OGU0ODAyMmVlZTU2In0.L3NBJEqrvAjltm9iQKY0XOOnSQCjY2abiDW5mkL1bKTlPpoZlBe88cbU8K_Y0WCACYIjstfVCpsmQiEMGbPh2Byth1k1u45DmLe47fI0A3jy9DRtLxQtvQJYkDq3dKJGrVbWH6bwjvmXqpqhwzPnage2IpKhsaKhFWcGNaQGyfr6DyjMYEw5NTJ8YL-6DI1NCn7YZkq4dsOAHUtFG15X0uiFpJew7M1nSg96k6FBN5tfgLFup4Pww2tEirS2tdU5MtKbe6MbR_TA56v2hr7R6iJ9tZTqLUyXLhrsNZcrUKl7cu8R_53fNgE1GHYir-ZHns-vgFJok4jDXYFReYih5w", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("❌ Error fetching logs:", error?.localizedDescription ?? "Unknown error")
            completion([])
            return
        }

        do {
            // Decode JSON response
            let decodedResponse = try JSONDecoder().decode([LogEntry].self, from: data)

                      // ✅ Extract only relevant log entries that contain questions
                      let questions = decodedResponse.compactMap { log in
                          // ✅ Ensure the text isn't improperly formatted as JSON inside a string
                          log.log_entry.contains("?") || log.log_entry.contains("interview questions:") ? cleanQuestionText(log.log_entry) : nil
                      }

            DispatchQueue.main.async {
                completion(questions)
            }

        } catch {
            print("❌ Error decoding response:", error.localizedDescription)

            if let jsonString = String(data: data, encoding: .utf8) {
                print("📜 Raw JSON Response:\n\(jsonString)")
            }

            completion([])
        }
    }.resume()
}


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

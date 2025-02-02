//
//  NasaDataService.swift
//  InterView
//
//  Created by Christopher Woods on 2/1/25.
//


//
//  DataService.swift
//  NasaAPI
//
//  Created by Christopher Woods on 11/2/23.
//

import Foundation


//setDate(current: date)
class ResumeDataService {
    private let baseURLString = "https://little-resonance-af2f.noshirt23penguin.workers.dev"
  
    func fetchProcessedQuestions(completion: @escaping (String) -> Void) {
        let agentAddress = "agent1qwqpl4m8kzc7mskuax8xstwcw9xdskxgpd5fzhw67zcxefdhax5kvycjnz8"
        let urlString = "https://agentverse.ai/v1/hosting/agents/\(agentAddress)/logs/latest"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion("")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer eyJhbGciOiJSUzI1NiJ9.eyJleHAiOjE3NDEwNTk1OTIsImlhdCI6MTczODQ2NzU5MiwiaXNzIjoiZmV0Y2guYWkiLCJqdGkiOiIwNTBkMGJhYjM1MjUxNDU1ODhkNTMwZTQiLCJzY29wZSI6ImF2OnJvIiwic3ViIjoiODNlMTY5MzBiM2FlMzA5Y2M0YzcwNGE5NDY3MDgwNjY1MjY0OGU0ODAyMmVlZTU2In0.L3NBJEqrvAjltm9iQKY0XOOnSQCjY2abiDW5mkL1bKTlPpoZlBe88cbU8K_Y0WCACYIjstfVCpsmQiEMGbPh2Byth1k1u45DmLe47fI0A3jy9DRtLxQtvQJYkDq3dKJGrVbWH6bwjvmXqpqhwzPnage2IpKhsaKhFWcGNaQGyfr6DyjMYEw5NTJ8YL-6DI1NCn7YZkq4dsOAHUtFG15X0uiFpJew7M1nSg96k6FBN5tfgLFup4Pww2tEirS2tdU5MtKbe6MbR_TA56v2hr7R6iJ9tZTqLUyXLhrsNZcrUKl7cu8R_53fNgE1GHYir-ZHns-vgFJok4jDXYFReYih5w", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching logs:", error?.localizedDescription ?? "Unknown error")
                completion("")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode([LogEntry].self, from: data)
                
                let questions = decodedResponse.compactMap { log in
                    
                    log.log_entry.contains("?") || log.log_entry.contains("interview questions:") ? cleanQuestionText(log.log_entry) : nil
                }

                DispatchQueue.main.async {
                    completion(questions[0])
                }
            } catch {
                print("Error decoding response:", error.localizedDescription)
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response:\n\(jsonString)")
                }

                completion("")
            }
        }.resume()
    }

//    func fetchResponse() async throws -> String {
//        guard let url = URL(string: baseURLString) else {
//            throw URLError(.badURL)
//        }
//        
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let response = try JSONDecoder().decode([Response].self, from: data)
//        return response[0].response
//    }
    
    func uploadResume(_ pdfText: String) async throws {
        guard let url = URL(string: "\(baseURLString)/resume") else {
            throw URLError(.badURL)
        }
        
        guard let httpBody = pdfText.data(using: .utf8) else {
            throw NSError(domain: "ResumeUpload", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Failed to encode PDF text"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // Optional: Parse response if needed
        if let responseString = String(data: data, encoding: .utf8) {
            print("Upload Response: \(responseString)")
        }
    }
}
    
    
    


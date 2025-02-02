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
    
    func fetchResponse() async throws -> String {
        guard let url = URL(string: baseURLString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode([Response].self, from: data)
        return response[0].response
    }
    
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
    
    
    


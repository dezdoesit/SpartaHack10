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
    var URLString = "https://little-resonance-af2f.noshirt23penguin.workers.dev"
    
    func fetchResponse() async throws -> String {
        guard let url = URL(string: URLString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode([Response].self, from: data)
        return response[0].response
    }
    func uploadResume(myResume: String){
        guard let url = URL(string: "https://dash.cloudflare.com/320fc87f048be5f63121e9f44adf2e84/workers/services/edit/little-resonance-af2f/production/resume") else { print("Invalid URL")
            return
        }

        guard let httpBody = myResume.data(using: .utf8) else {
            print("Error encoding string")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        // Step 5: Perform the request using URLSession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error)")
                return
            }
            
            // Step 6: Handle the response
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                } else {
                    print("Invalid response data")
                }
            }
        }.resume()
    }
    
    
    
    
}

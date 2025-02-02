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
}

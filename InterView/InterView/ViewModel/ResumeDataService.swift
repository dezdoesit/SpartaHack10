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
class ResumeDataService{
    
    var URLString = "https://little-resonance-af2f.noshirt23penguin.workers.dev"

    
    func fetchResponse(completion: @escaping(String) -> Void) {
        guard let url = URL(string: URLString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            print("starting")
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                print("doing")
                let response = try JSONDecoder().decode([Response].self, from: data)
                let result = response[0].response
                
                completion(result)
            } catch {
                print("Error decoding data: \(error)")
            }
            
            
        }.resume()
    }
    
    
    
    
}

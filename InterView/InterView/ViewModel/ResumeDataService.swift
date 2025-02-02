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
    
    var URLString = ""

    
    func fetchResponse(completion: @escaping(String) -> Void) {
        guard let url = URL(string: URLString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                let response = try JSONDecoder().decode(ResumeResponse.self, from: data)
                let result = response.
                
                completion(picture)
            } catch {
                print("Error decoding data: \(error)")
            }
            
            
        }.resume()
    }
    
    
    
    
}

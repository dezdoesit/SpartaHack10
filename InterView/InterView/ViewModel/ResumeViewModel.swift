//
//  NasaViewModel.swift
//  InterView
//
//  Created by Christopher Woods on 2/1/25.
//


//
//  NasaViewModel.swift
//  NasaAPI
//
//  Created by Christopher Woods on 11/2/23.
//

import Foundation


class ResumeViewModel: ObservableObject{
    
    @Published var questions = ""
    @Published var questionsParse: [String] = []

    
    
    private let service = ResumeDataService()
    
    init() {
        fetchResponse()
    }
    
    func fetchResponse() {
        print("starting fetch")
        service.fetchResponse() { result in
            DispatchQueue.main.async{
                self.questions = result
                self.questionsParse = self.questions.components(separatedBy: "\n\n")
                
            }
        }
        
    }
    
}

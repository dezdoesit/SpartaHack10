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


@MainActor
class ResumeViewModel: ObservableObject {
    @Published var currentQuestion: Question?
    @Published var questionsParse: [String] = []
    @Published var currentIndex = 0
    
    private let service = ResumeDataService()
    
    init() {
//        fetchResponse()
    }
    
    func fetchResponse() async {
        do {
            let result = try await service.fetchResponse()
            self.questionsParse = result.components(separatedBy: "\n\n")
            self.questionsParse.removeFirst()
            
            if !questionsParse.isEmpty {
                updateCurrentQuestion()
            }
        } catch {
            print("Error fetching response: \(error)")
        }
    }
    
    func nextQuestion() {
        if currentIndex < questionsParse.count - 1 {
            currentIndex += 1
            updateCurrentQuestion()
        }
    }
    
    func previousQuestion() {
        if currentIndex > 0 {
            currentIndex -= 1
            updateCurrentQuestion()
        }
        
    }
    func uploadResume(myResume: String){
        service.uploadResume(myResume: myResume)
    }
    
    private func updateCurrentQuestion() {
        currentQuestion = Question(
            text: questionsParse[currentIndex],
            index: currentIndex + 1
        )
    }
}

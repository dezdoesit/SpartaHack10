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
    @Published var uploadStatus: UploadStatus = .idle
    
    enum UploadStatus {
        case idle
        case uploading
        case success
        case error(Error)
    }
    
    private let service = ResumeDataService()
    
    func uploadResume(_ pdfText: String) async throws {
        uploadStatus = .uploading
        do {
            try await service.uploadResume(pdfText)
            uploadStatus = .success
            // After successful upload, fetch new questions
            await fetchResponse()
        } catch {
            uploadStatus = .error(error)
            throw error
        }
    }
    
    func fetchResponse() async {
        do {
            let result = try await service.fetchResponse()
            self.questionsParse = result.components(separatedBy: "\n\n")
            if !self.questionsParse.isEmpty {
                updateCurrentQuestion()
            }
        } catch {
            print("Error fetching response: \(error)")
        }
    }
    
    private func updateCurrentQuestion() {
        currentQuestion = Question(
            text: questionsParse[currentIndex],
            index: currentIndex + 1
        )
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
}

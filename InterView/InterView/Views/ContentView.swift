//
//  ContentView.swift
//  InterView
//
//  Created by Dezmond Blair on 2/1/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

//struct ContentView: View {
//    @ObservedObject var resumeVM = ResumeViewModel()
//
//    var body: some View {
//        VStack {
//            
//            Text(resumeVM.questions)
//            Button(action: {print("array: \(resumeVM.questionsParse)")}
//                   , label: {Text("Press ME")})
////            Text("Welcome to your interview!")
////                .font(.extraLargeTitle)
////            
////            Model3D(named: "Scene", bundle: realityKitContentBundle)
////                .padding(.bottom, 50)
////
////
////            PDFPickerView()
////            FreeFormDrawingView()
//        }
//        .padding()
////        .onAppear(){
////            print(extractWordsFromPDF(fileURL: Bundle.main.url(forResource: "sample", withExtension: "pdf")!)!.joined(separator: " "))
////        }
//    }
//}

struct ContentView: View {
    @StateObject var resumeVM = ResumeViewModel()
    @State private var isUploading = false
    @State private var uploadError: Error?
    
    var body: some View {
        VStack(spacing: 20) {
            if isUploading {
                ProgressView("Uploading Resume...")
            }
            Button("GET GRADE"){
                Task{
                    do{
                        try await resumeVM.getGrade()
                    }
                }
                print(resumeVM.grade)
            }
//            PDFPickerView(resumeVM: resumeVM)
            
            if let error = uploadError {
                Text("Upload Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
            
            // Add both SpeechView and SpeechToTextTestView after successful PDF upload
            if case .success = resumeVM.uploadStatus {
                InterviewSessionView(resumeVM: resumeVM, questions: resumeVM.questions)
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

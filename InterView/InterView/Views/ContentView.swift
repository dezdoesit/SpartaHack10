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
    
    var body: some View {
        VStack(spacing: 20) {
            if let question = resumeVM.currentQuestion {
                Text("Question \(question.index)")
                    .font(.headline)
                
                Text(question.text)
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack(spacing: 20) {
                    Button(action: {
                        resumeVM.previousQuestion()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                    }
                    .disabled(resumeVM.currentIndex == 0)
                    
                    Button(action: {
                        resumeVM.nextQuestion()
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                    }
                    .disabled(resumeVM.currentIndex == resumeVM.questionsParse.count - 1)
                }
            } else {
                ProgressView("Loading questions...")
            }
        }
        .padding()
    }
}
#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

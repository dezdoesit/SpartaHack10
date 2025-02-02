//
//  ContentView.swift
//  InterView
//
//  Created by Dezmond Blair on 2/1/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @ObservedObject var resumeVM = ResumeViewModel()

    var body: some View {
        VStack {
            
            Text(resumeVM.questions)
            Button(action: {print(resumeVM.questions)}
                   , label: {Text("Press ME")})
//            Text("Welcome to your interview!")
//                .font(.extraLargeTitle)
//            
//            Model3D(named: "Scene", bundle: realityKitContentBundle)
//                .padding(.bottom, 50)
//
//
//            PDFPickerView()
            FreeFormDrawingView()
        }
        .padding()
//        .onAppear(){
//            print(extractWordsFromPDF(fileURL: Bundle.main.url(forResource: "sample", withExtension: "pdf")!)!.joined(separator: " "))
//        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

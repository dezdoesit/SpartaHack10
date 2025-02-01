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

    var body: some View {
        VStack {
            Text("Welcome to your interview!")
                .font(.extraLargeTitle)
            
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)


            PDFPickerView()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

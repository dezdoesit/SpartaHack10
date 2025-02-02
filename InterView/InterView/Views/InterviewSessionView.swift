//
//  InterviewSessionView.swift
//  InterView
//
//  Created by Dezmond Blair on 2/2/25.
//

import SwiftUI

struct InterviewSessionView: View {
    let questions: [Question]
    
    var body: some View {
        VStack(spacing: 30) {
            // Question display and speech synthesis
            SpeechView(myArray: questions)
            
            Divider()
                .padding(.vertical)
            
            // Speech-to-text recognition
            SpeechToTextTestView()
        }
    }
}


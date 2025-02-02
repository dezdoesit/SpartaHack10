//
//  SpeechView.swift
//  InterView
//
//  Created by Dezmond Blair on 2/2/25.
//

import SwiftUI
import AVFoundation

struct SpeechView: View {
    @State var count = 0
    var myArray: [Question] = [Question(text: "default", index: 0)]
    @StateObject private var speechManager = SpeechManager()
    
    var body: some View {
        VStack(spacing: 20) {
            // Display current question
            Text("Question \(myArray[count].index):")
                    .font(.headline)
            Text(myArray[count].text)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
            // Speech controls
            HStack(spacing: 20) {
                Button(action: {
                    speechManager.speak(text: myArray[count].text)
                    
                }) {
                    Label("Speak Question", systemImage: "play.circle.fill")
                        .font(.title2)
                }
                .disabled(speechManager.isSpeaking)
                
                Button(action: {
                    speechManager.stopSpeaking()
                }) {
                    Label("Stop", systemImage: "stop.circle.fill")
                        .font(.title2)
                }
                .disabled(!speechManager.isSpeaking)
            }
            
            // Navigation buttons
            HStack(spacing: 30) {
                Button(action: {
                    count -= 1
                }) {
                    Label("Previous", systemImage: "arrow.left.circle.fill")
                }
                .disabled(count == 0)
                
                Button(action: {
                    count += 1
                }) {
                    Label("Next", systemImage: "arrow.right.circle.fill")
                }
                .disabled(count >= myArray.count - 1)
            }
            .padding(.top, 20)
        
    }
}

@MainActor
class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(text: String) {
        stopSpeaking()
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        // Use a natural sounding voice
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = voice
        }
        
        Task { @MainActor in
            isSpeaking = true
            synthesizer.speak(utterance)
        }
    }
    
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            isSpeaking = false
        }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            isSpeaking = false
        }
    }
}

// MARK: - Preview
#Preview {
    SpeechView()
}

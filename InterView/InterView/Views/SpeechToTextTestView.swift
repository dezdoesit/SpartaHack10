import SwiftUI
import AVFoundation


struct SpeechToTextTestView: View {
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var fullTranscript: String = ""
    @ObservedObject var resumeVM: ResumeViewModel
    
    var body: some View {
        VStack {
            Text("Live Transcript:")
                .font(.headline)
            Text(speechRecognizer.transcript)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .border(Color.gray, width: 1)
            
            Button(action: toggleRecording) {
                Text(isRecording ? "Stop Listening" : "Start Listening")
                    .padding()
                    .background(isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Button("Show Full Transcript") {
                fullTranscript = speechRecognizer.getFullTranscript()
               
               
            }
            .padding()
            Button("Grade Answers"){
                Task{
                    do{
                        try await resumeVM.uploadA(answers: fullTranscript)
                    }
                }
            }
           
            ScrollView {
                Text(fullTranscript)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
    
    private func toggleRecording() {
        if isRecording {
            speechRecognizer.stopTranscribing()
            isRecording = false
        } else {
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing()
            isRecording = true
        }
    }
}


#Preview {
    SpeechToTextTestView(resumeVM: ContentView().resumeVM)
}

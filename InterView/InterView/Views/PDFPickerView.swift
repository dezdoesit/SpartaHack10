//import SwiftUI
//import UniformTypeIdentifiers
//import Vision
//
//struct PDFPickerView: View {
//    @ObservedObject var resumeVM: ResumeViewModel
//    @State private var showingDocumentPicker = false
//    @State private var selectedPDF: URL?
//    @State private var isProcessing = false
//    @State private var error: Error?
//
//    var body: some View {
//        VStack {
//            Button("Select PDF") {
//                showingDocumentPicker = true
//            }
//            .disabled(isProcessing)
//            
//            if isProcessing {
//                ProgressView("Processing PDF...")
//            }
//            
//            if let selectedPDF {
//                Text("Selected: \(selectedPDF.lastPathComponent)")
//            }
//            
//            if let error {
//                Text("Error: \(error.localizedDescription)")
//                    .foregroundColor(.red)
//            }
//        }
//        .fileImporter(
//            isPresented: $showingDocumentPicker,
//            allowedContentTypes: [UTType.pdf],
//            allowsMultipleSelection: false
//        ) { result in
//            handlePDFSelection(result)
//        }
//    }
//
//    private func handlePDFSelection(_ result: Result<[URL], Error>) {
//        Task {
//            do {
//                isProcessing = true
//                error = nil
//                
//                switch result {
//                case .success(let urls):
//                    if let url = urls.first {
//                        selectedPDF = url
//                        
//                        // Ensure the file is fully downloaded from iCloud if necessary
//                        if url.isFileURL {
//                            // Access the file securely if needed (iCloud specific)
//                            if url.startAccessingSecurityScopedResource() {
//                                defer { url.stopAccessingSecurityScopedResource() }
//                                
//                                // Extract text from the PDF
//                                if let pdfText = extractWordsFromPDF(fileURL: url) {
//                                    try await resumeVM.uploadResume(pdfText)
//                                } else {
//                                    throw NSError(domain: "PDFProcessing", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to extract text from PDF"])
//                                }
//                            } else {
//                                throw NSError(domain: "FileAccess", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to access iCloud file"])
//                            }
//                        }
//                    }
//                case .failure(let selectionError):
//                    throw selectionError
//                }
//            } catch {
//                self.error = error
//            }
//            isProcessing = false
//        }
//    }
//
//}

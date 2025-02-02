//
//  PDFPickerView.swift
//  InterView
//
//  Created by Dezmond Blair on 2/1/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct PDFPickerView: View {
    @State private var showingDocumentPicker = false
    @State private var selectedPDF: URL?
    @State private var myPDFWords: [String] = []
    
    var body: some View {
        VStack {
            Button("Select PDF") {
                showingDocumentPicker = true
            }
            
            if let selectedPDF {
                Text("Selected: \(selectedPDF.lastPathComponent)")
            }
        }
        .fileImporter(
            isPresented: $showingDocumentPicker,
            allowedContentTypes: [UTType.pdf],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    selectedPDF = url
                    myPDFWords = extractWordsFromPDF(fileURL: selectedPDF!)!
                    // Here you can handle the PDF file
                }
            case .failure(let error):
                print("Error selecting PDF: \(error.localizedDescription)")
            }
        }
    }
}

//
//  PDFExtract.swift
//  InterView
//
//  Created by Christopher Woods on 2/1/25.
//

import PDFKit

func extractWordsFromPDF(fileURL: URL) -> String? {
    // Create a PDFDocument from the file URL
    guard let pdfDocument = PDFDocument(url: fileURL) else {
        print("Could not load PDF document")
        return nil
    }
    
    var words: [String] = []
    
    // Loop through all the pages in the PDF
    for pageIndex in 0..<pdfDocument.pageCount {
        guard let page = pdfDocument.page(at: pageIndex) else {
            continue
        }
        
        // Extract text from the page
        if let pageText = page.string {
            // Split the text into words by whitespace or non-word characters
            let pageWords = pageText.split { !$0.isLetter && !$0.isNumber }
                                     .map { String($0) }
            words.append(contentsOf: pageWords)
        }
    }
    
    return words.joined(separator: " ")
}


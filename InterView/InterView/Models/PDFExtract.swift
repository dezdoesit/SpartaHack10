import PDFKit


// Extract words from the PDF
func extractWordsFromPDF(fileURL: URL) -> String? {
    
    var words: [String] = []
    print("Attempting to load PDF at URL: \(fileURL)")
    
    // Check if file exists locally or needs to be downloaded
    downloadFileIfNeeded(from: fileURL) { localURL in
        guard let localURL = localURL else {
            print("File could not be downloaded or found.")
            return
        }
        
        // Create a PDFDocument from the local file URL
        guard let pdfDocument = PDFDocument(url: localURL) else {
            print("Could not load PDF document at URL: \(localURL)")
            return
        }

        
        // Loop through all the pages in the PDF
        for pageIndex in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex) else {
                print("Could not retrieve page at index: \(pageIndex)")
                continue
            }
            
            // Extract text from the page
            if let pageText = page.string {
                print("Extracted text from page \(pageIndex): \(pageText.prefix(100))...")  // Print part of the text for debugging
                // Split the text into words by whitespace or non-word characters
                let pageWords = pageText.split { !$0.isLetter && !$0.isNumber }
                                         .map { String($0) }
                words.append(contentsOf: pageWords)
            } else {
                print("No text extracted from page \(pageIndex)")
            }
        }

    }
    return words.joined(separator: " ")
}

// Download file from iCloud if it's not already available locally
func downloadFileIfNeeded(from fileURL: URL, completion: @escaping (URL?) -> Void) {
    let fileManager = FileManager.default

    // Check if the file exists at the given URL
    if fileManager.fileExists(atPath: fileURL.path) {
        completion(fileURL) // File is already available locally
        return
    }
    
    // Attempt to download the iCloud file
    let documentURL = fileURL.deletingLastPathComponent()
    let fileName = fileURL.lastPathComponent
    
    // Accessing iCloud Documents directory
    let iCloudURL = documentURL.appendingPathComponent(fileName)
    
    // Check if the iCloud URL is accessible
    if let document = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: iCloudURL, create: false) {
        // Define the destination URL for the file
        let destinationURL = document.appendingPathComponent(fileName)
        
        // If the file isn't downloaded yet, copy it to the local directory
        if !fileManager.fileExists(atPath: destinationURL.path) {
            do {
                try fileManager.copyItem(at: fileURL, to: destinationURL)
                print("File downloaded to: \(destinationURL.path)")
                completion(destinationURL)
            } catch {
                print("Error downloading iCloud file: \(error)")
                completion(nil)
            }
        } else {
            // If the file is already present locally, proceed with it
            completion(destinationURL)
        }
    } else {
        print("Error: Could not access iCloud file")
        completion(nil)
    }
}


import Foundation
import Combine
import UIKit
import Vision

@MainActor
final class ScannerViewModel: ObservableObject {
    @Published var extractedText = ""
    @Published var isScanning = false
    @Published var errorMessage = ""

    func extractText(from image: UIImage) async {
        isScanning = true
        errorMessage = ""
        defer { isScanning = false }

        guard let cgImage = image.cgImage else {
            errorMessage = "Invalid image."
            return
        }

        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["fr-CA", "fr-FR", "en-US"]
        request.usesLanguageCorrection = true

        do {
            let handler = VNImageRequestHandler(cgImage: cgImage)
            try handler.perform([request])
            let text = request.results?
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n") ?? ""

            extractedText = text

            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errorMessage = "No text was detected in this image."
            }
        } catch {
            errorMessage = "Unable to analyze this image."
        }
    }
}

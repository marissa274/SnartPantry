import Foundation
import AVFoundation
import Combine

final class RecipeSpeechManager: NSObject, ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    private var hasPreparedAudioSession = false

    @Published var isSpeaking = false
    @Published var isPaused = false
    @Published private(set) var completedUtteranceCount = 0

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func prepareForPlayback() {
        guard !hasPreparedAudioSession else { return }

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true, options: [])
            hasPreparedAudioSession = true
        } catch {
            // Keep speech available even if session setup fails.
        }
    }

    func speakStep(_ step: String) {
        prepareForPlayback()
        stop()

        let utterance = AVSpeechUtterance(string: step)
        utterance.voice = AVSpeechSynthesisVoice(language: "fr-CA")
        utterance.rate = 0.42
        utterance.pitchMultiplier = 1.0

        synthesizer.speak(utterance)
        isSpeaking = true
        isPaused = false
    }

    func speakRecipe(title: String, steps: [String]) {
        prepareForPlayback()
        stop()

        let allSteps = steps.enumerated().map {
            "Étape \($0.offset + 1). \($0.element)"
        }.joined(separator: " ")

        let text = "Recette \(title). \(allSteps)"

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "fr-CA")
        utterance.rate = 0.42
        utterance.pitchMultiplier = 1.0

        synthesizer.speak(utterance)
        isSpeaking = true
        isPaused = false
    }

    func pause() {
        guard synthesizer.isSpeaking else { return }
        synthesizer.pauseSpeaking(at: .word)
        isPaused = true
    }

    func resume() {
        guard synthesizer.isPaused else { return }
        synthesizer.continueSpeaking()
        isPaused = false
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        isPaused = false
    }
}

extension RecipeSpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
        completedUtteranceCount += 1
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
    }
}

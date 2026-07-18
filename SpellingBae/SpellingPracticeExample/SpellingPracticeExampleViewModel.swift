//
//  SpellingPracticeViewModel.swift
//  SignLanguageApp
//

import Foundation
import Observation
import Speech
import AVFoundation

enum SpellingState {
    case idle
    case recording
    case correct
    case tryAgain
}

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
}

@MainActor
@Observable
final class SpellingPracticeExampleViewModel {
    var state: SpellingState = .idle
    var recognizedText: String = ""
    var targetWord: String = ""
    var result: SpellingResult?
    var difficulty: Difficulty = .easy {
        didSet {
            guard difficulty != oldValue else { return }
            reset()
        }
    }

    private static let easyWordList = [
        "CAT", "DOG", "SUN", "HAT", "BIG",
        "MAP", "CUP", "FAN", "JOY", "ZAP"
    ]

    private static let mediumWordList = [
        "BEAUTIFUL", "BECAUSE", "BELIEVE", "BICYCLE", "BUSINESS",
        "CALENDAR", "CHOCOLATE", "DIFFERENT", "DIFFICULT", "ENVIRONMENT",
        "FAVORITE", "FEBRUARY", "FOREIGN", "GRAMMAR", "HOSPITAL",
        "IMPORTANT", "KNOWLEDGE", "LANGUAGE", "LIBRARY", "NECESSARY",
        "NEIGHBOR", "OPPORTUNITY", "PARALLEL", "RESTAURANT", "RHYTHM",
        "SEPARATE", "TEMPERATURE", "TOMORROW", "VEGETABLE", "WEDNESDAY"
    ]

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isTapInstalled = false
    private let normalizer = SpellingNormalizer()

    init() {
        targetWord = Self.randomWord(for: difficulty)
    }

    func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { _ in }
        AVAudioApplication.requestRecordPermission { _ in }
    }

    func startRecording() {
        guard state != .recording else { return }
        stopRecording()

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let request = recognitionRequest else { return }
        request.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        if !isTapInstalled {
            let format = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
                self?.recognitionRequest?.append(buffer)
            }
            isTapInstalled = true
        }

        audioEngine.prepare()
        try? audioEngine.start()

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, _ in
            guard let self, let result else { return }
            let text = result.bestTranscription.formattedString
            Task { @MainActor in
                self.recognizedText = text
            }
        }

        state = .recording
    }

    func stopAndEvaluate() {
        let raw = recognizedText
        stopRecording()

        let spellingResult = normalizer.evaluate(transcript: raw, target: targetWord)
        result = spellingResult
        state = spellingResult.isCorrect ? .correct : .tryAgain
    }

    func reset() {
        recognizedText = ""
        result = nil
        targetWord = Self.randomWord(for: difficulty)
        state = .idle
    }

    private static func randomWord(for difficulty: Difficulty) -> String {
        let list: [String]
        switch difficulty {
        case .easy:  list = easyWordList
        case .medium: list = mediumWordList
        }
        return list.randomElement() ?? "CAT"
    }

    private func stopRecording() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        recognitionRequest = nil

        if isTapInstalled {
            audioEngine.inputNode.removeTap(onBus: 0)
            isTapInstalled = false
        }

        if audioEngine.isRunning {
            audioEngine.stop()
        }

        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

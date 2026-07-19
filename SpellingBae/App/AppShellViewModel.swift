//
//  AppShellViewModel.swift
//  SpellingBae
//
//  Drives navigation and the Listen & Spell practice session for the iPad shell.
//

import Foundation
import Observation
import AVFoundation
import SwiftUI

enum AppScreen: Hashable {
    case home, practice, progress, hive, settings
}

enum AnswerState {
    case idle, correct, incorrect
}

@MainActor
@Observable
final class AppShellViewModel {
    // Navigation
    var screen: AppScreen = .home

    // Player stats
    var honey: Int = 340
    var streak: Int = 4

    // Session state
    let words = ["garden", "yellow", "friend", "school", "flower"]
    var wordIndex: Int = 0
    var typed: String = ""
    var answer: AnswerState = .idle
    var audioPulse: Bool = false

    private let keyboardRows = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    private let synthesizer = AVSpeechSynthesizer()
    private var pulseTask: Task<Void, Never>?

    // MARK: - Derived

    var currentWord: String { words[wordIndex] }
    var questionNumber: Int { wordIndex + 1 }
    var totalWords: Int { words.count }
    var progressFraction: Double { Double(wordIndex) / Double(words.count) }
    var keyRows: [[Character]] { keyboardRows.map(Array.init) }
    var canCheck: Bool { !typed.isEmpty && answer != .correct }

    // MARK: - Navigation

    func go(to screen: AppScreen) {
        self.screen = screen
    }

    func startSession() {
        wordIndex = 0
        typed = ""
        answer = .idle
        screen = .practice
    }

    func exitToHome() {
        stopAudio()
        screen = .home
    }

    // MARK: - Typing

    func tap(_ letter: Character) {
        guard answer != .correct else { return }
        if answer == .incorrect { answer = .idle }
        guard typed.count < currentWord.count else { return }
        typed.append(letter)
    }

    func backspace() {
        guard answer != .correct else { return }
        if answer == .incorrect { answer = .idle }
        _ = typed.popLast()
    }

    func check() {
        guard canCheck else { return }
        if typed.lowercased() == currentWord {
            answer = .correct
            honey += 15
        } else {
            answer = .incorrect
        }
    }

    func nextWord() {
        if wordIndex >= words.count - 1 {
            exitToHome()
            wordIndex = 0
            typed = ""
            answer = .idle
            return
        }
        wordIndex += 1
        typed = ""
        answer = .idle
    }

    // MARK: - Audio

    /// Speaks the current word aloud and triggers the pulse ring animation.
    func playAudio(slow: Bool = false) {
        audioPulse = true
        pulseTask?.cancel()
        pulseTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(900))
            guard !Task.isCancelled else { return }
            self?.audioPulse = false
        }

        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: currentWord)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = slow ? 0.32 : AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }

    private func stopAudio() {
        pulseTask?.cancel()
        audioPulse = false
        synthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - Per-slot rendering

    struct Slot: Identifiable {
        let id: Int
        let character: String
        let fill: Color
        let border: Color
        let text: Color
        let isCurrent: Bool
    }

    func slots() -> [Slot] {
        let target = Array(currentWord)
        let entered = Array(typed)
        return target.indices.map { i in
            let filled = i < entered.count
            var fill = Bae.slotFill
            var border = Bae.slotBorder
            var text = Bae.ink

            switch answer {
            case .correct:
                fill = Bae.correctFill; border = Bae.correctBorder; text = Bae.correctInk
            case .incorrect:
                let ok = filled && String(entered[i]).lowercased() == String(target[i])
                fill = ok ? Bae.correctFill : Bae.wrongFill
                border = ok ? Bae.correctBorder : Bae.wrongBorder
                text = ok ? Bae.correctInk : Bae.streak
            case .idle:
                break
            }

            return Slot(
                id: i,
                character: filled ? String(entered[i]).uppercased() : "",
                fill: fill,
                border: border,
                text: text,
                isCurrent: i == entered.count && answer == .idle
            )
        }
    }
}

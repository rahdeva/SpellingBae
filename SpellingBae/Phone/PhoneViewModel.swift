//
//  PhoneViewModel.swift
//  SpellingBae
//
//  State machine for the full iPhone flow: splash → onboarding → level →
//  home / practice / session / summary / progress / hive / settings, plus
//  overlays (permission, errors) and a toast.
//

import Foundation
import Observation
import SwiftUI
import AVFoundation

// MARK: - Enums

enum PhoneScreen: Hashable {
    case splash, onboard, level, home, practice, session, summary
    case daily, mistakes, progress, badges, hive, settings
}

enum PracticeMode: String, Hashable {
    case listen, spell, say, mixed
}

enum SessionAnswer { case idle, correct, incorrect }
enum MicState { case ready, recording, processing, success, failed }

enum PhoneOverlay: Equatable {
    case permission
    case error(ErrorKind)

    enum ErrorKind: String { case audio, voice, noise, denied }

    var isError: Bool { if case .error = self { return true } else { return false } }
}

// MARK: - Data models

struct WordItem {
    let word, cat, emoji, def, sentence: String
    let mode: PracticeMode
    let status: String
}

struct OnboardPage {
    let mood: BaeMood
    let title, body: String
}

struct LevelOption: Identifiable {
    let id: String
    let name, emoji, desc, examples: String
    let tint, border: Color
}

// MARK: - View model

@MainActor
@Observable
final class PhoneViewModel {
    // Flow
    var screen: PhoneScreen = .splash
    var onboardPage: Int = 0
    var level: String? = nil
    var micGranted = false

    // Stats
    var honey = 340
    var stars = 12
    var streak = 4
    var lastHoney = 0
    var lastStars = 0

    // Session
    var mode: PracticeMode = .listen
    var wordIndex = 0
    var typed = ""
    var answer: SessionAnswer = .idle
    var attempt = 1
    var hintLevel = 0
    var showHintCard = false
    var mic: MicState = .ready
    var recognized = ""
    var audioPulse = false

    // Session totals
    var sessCorrect = 0
    var sessStars = 0
    var sessHoney = 0

    // Settings
    var soundFx = true
    var music = false
    var reduceMotion = false
    var speedSlow = false

    // Overlays
    var overlay: PhoneOverlay? = nil
    var toastMessage: String? = nil

    private let synthesizer = AVSpeechSynthesizer()
    private var pulseTask: Task<Void, Never>?
    private var micTask: Task<Void, Never>?
    private var toastTask: Task<Void, Never>?

    // MARK: Static content

    static let onboarding: [OnboardPage] = [
        .init(mood: .wave, title: "Hi, I'm Bae! 🐝",
              body: "I'm your spelling bestie. Let's collect words and grow our hive together!"),
        .init(mood: .happy, title: "Hear it",
              body: "Tap the big honey button to listen. You can replay the word as many times as you like."),
        .init(mood: .think, title: "Say it or spell it",
              body: "Type the letters, arrange tiles, or use your voice to spell the word out loud."),
        .init(mood: .cheer, title: "Earn honey!",
              body: "Every word you learn fills the honeycomb and grows your hive. Ready to buzz?"),
    ]

    static let levels: [LevelOption] = [
        .init(id: "beginner", name: "Beginner", emoji: "🌱",
              desc: "Short 3–4 letter words with picture hints.", examples: "cat, dog, sun, book",
              tint: Color(hex: 0xE9F7E5), border: Color(hex: 0xBBE3AE)),
        .init(id: "intermediate", name: "Intermediate", emoji: "🌻",
              desc: "5–7 letters with a few tricky silent letters.", examples: "school, friend, yellow",
              tint: Color(hex: 0xFFF1D6), border: Color(hex: 0xF2D89A)),
        .init(id: "advanced", name: "Advanced", emoji: "🌺",
              desc: "Longer words and academic vocabulary.", examples: "beautiful, language",
              tint: Color(hex: 0xFDE6E0), border: Color(hex: 0xF5C3B4)),
    ]

    static let words: [WordItem] = [
        .init(word: "garden", cat: "Nature", emoji: "🌼", def: "A place where plants and flowers grow.",
              sentence: "We planted roses in the garden.", mode: .listen, status: "New"),
        .init(word: "yellow", cat: "Colors", emoji: "🌞", def: "The bright colour of the sun and honey.",
              sentence: "Bae is a happy yellow bee.", mode: .listen, status: "Learning"),
        .init(word: "friend", cat: "People", emoji: "🤝", def: "Someone you like and play with.",
              sentence: "Bae is my best friend.", mode: .spell, status: "Learning"),
        .init(word: "school", cat: "Places", emoji: "🏫", def: "A place where children go to learn.",
              sentence: "I walk to school every day.", mode: .say, status: "Needs Review"),
        .init(word: "flower", cat: "Nature", emoji: "🌸", def: "The pretty, colourful part of a plant.",
              sentence: "The bee lands on a soft flower.", mode: .listen, status: "New"),
    ]

    private static let keyboardRows = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]

    // MARK: Derived

    var currentWord: WordItem { Self.words[wordIndex] }
    var totalWords: Int { Self.words.count }
    var questionNumber: Int { wordIndex + 1 }

    /// In mixed mode each word carries its own mode.
    var effectiveMode: PracticeMode {
        mode == .mixed ? currentWord.mode : mode
    }

    var progressFraction: Double {
        Double(wordIndex + (answer == .correct ? 1 : 0)) / Double(totalWords)
    }

    var keyRows: [[Character]] { Self.keyboardRows.map(Array.init) }
    var canCheck: Bool { !typed.isEmpty && answer != .correct }
    var showKeyboard: Bool { effectiveMode == .listen && answer != .correct }
    var isVoiceMode: Bool { effectiveMode == .spell || effectiveMode == .say }

    var instruction: String {
        switch effectiveMode {
        case .listen: return "Listen, then spell the word!"
        case .spell: return "Say each letter out loud, one by one."
        default: return "Listen, then say the whole word!"
        }
    }

    var micHint: String {
        effectiveMode == .spell
            ? "Tap and spell it: " + currentWord.word.uppercased().map(String.init).joined(separator: "-")
            : "Tap, then say the word"
    }

    var correctTitle: String { attempt > 1 ? "You got it!" : "Bee-lievable! 🎉" }
    var incorrectTitle: String { attempt >= 3 ? "That was a tricky word!" : "Almost there!" }

    struct Slot: Identifiable {
        let id: Int
        let character: String
        let fill, border, text: Color
        let isCurrent: Bool
    }

    func slots() -> [Slot] {
        let target = Array(currentWord.word)
        let entered = Array(typed)
        return target.indices.map { i in
            let filled = i < entered.count
            var fill = Bae.slotFill, border = Bae.slotBorder, text = Bae.ink
            switch answer {
            case .correct:
                fill = Bae.correctFill; border = Bae.correctBorder; text = Bae.correctInk
            case .incorrect:
                let ok = filled && String(entered[i]).lowercased() == String(target[i]).lowercased()
                fill = ok ? Bae.correctFill : Bae.wrongFill
                border = ok ? Bae.correctBorder : Bae.wrongBorder
                text = ok ? Bae.correctInk : Bae.streak
            case .idle:
                break
            }
            return Slot(id: i, character: filled ? String(entered[i]).uppercased() : "",
                        fill: fill, border: border, text: text,
                        isCurrent: i == entered.count && answer == .idle)
        }
    }

    struct HintRow: Identifiable {
        let id: Int
        let icon: String
        let text: String
        let revealed: Bool
    }

    func hints() -> [HintRow] {
        let w = currentWord
        let items: [(String, String)] = [
            ("🔢", "\(w.word.count) letters"),
            ("🅰️", "Starts with “\(w.word.prefix(1).uppercased())”"),
            ("📖", w.def),
            ("✏️", "“\(w.sentence)”"),
        ]
        return items.enumerated().map { i, item in
            HintRow(id: i, icon: item.0,
                    text: i < hintLevel ? item.1 : "Tap Hint again to reveal",
                    revealed: i < hintLevel)
        }
    }

    var starRow: String {
        String(repeating: "⭐", count: lastStars) + String(repeating: "☆", count: max(0, 3 - lastStars))
    }

    var showTabs: Bool {
        [.home, .practice, .progress, .hive, .settings].contains(screen)
    }

    // MARK: - Navigation

    func go(_ screen: PhoneScreen) {
        self.screen = screen
        showHintCard = false
    }

    func toOnboard() { go(.onboard) }

    func nextOnboard() {
        if onboardPage >= Self.onboarding.count - 1 { go(.level) }
        else { onboardPage += 1 }
    }

    func finishOnboard() { go(.level) }

    func pickLevel(_ id: String) {
        level = id
        go(.home)
    }

    // MARK: - Session

    func startSession(_ mode: PracticeMode) {
        let needMic = (mode == .spell || mode == .say)
        if needMic && !micGranted {
            self.mode = mode
            overlay = .permission
            return
        }
        self.mode = mode
        wordIndex = 0; typed = ""; answer = .idle; attempt = 1
        hintLevel = 0; showHintCard = false; mic = .ready; recognized = ""
        sessCorrect = 0; sessStars = 0; sessHoney = 0
        go(.session)
    }

    func startMixedPractice() { startSession(.mixed) }

    func keyLetter(_ l: Character) {
        guard answer != .correct else { return }
        if answer == .incorrect { answer = .idle }
        typed.append(l)
    }

    func backspace() {
        guard answer != .correct else { return }
        _ = typed.popLast()
    }

    func clearAll() { typed = "" }

    func check() {
        guard !typed.isEmpty else { return }
        if typed.lowercased() == currentWord.word.lowercased() {
            let gained = hintLevel > 0 ? 8 : (attempt > 1 ? 10 : 15)
            let st = hintLevel > 0 ? 1 : (attempt > 1 ? 2 : 3)
            answer = .correct
            honey += gained; lastHoney = gained; lastStars = st
            sessHoney += gained; sessCorrect += 1; sessStars += st
        } else {
            answer = .incorrect
            attempt += 1
        }
    }

    func tryAgain() {
        answer = .idle
        typed = ""
    }

    func switchTyping() {
        mode = .listen
        mic = .ready
        answer = .idle
    }

    func useHint() {
        showHintCard = true
        hintLevel = min(hintLevel + 1, 4)
    }

    func closeHint() { showHintCard = false }

    // Simulated speech recognition (mirrors the design demo). Real recognition
    // can be layered in later via SpellingNormalizer + the Speech framework.
    func startRecording() {
        mic = .recording
        micTask?.cancel()
        micTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(1600))
            guard let self, !Task.isCancelled else { return }
            await self.finishRecognition()
        }
    }

    func stopRecording() {
        micTask?.cancel()
        micTask = Task { [weak self] in
            await self?.finishRecognition()
        }
    }

    private func finishRecognition() async {
        mic = .processing
        try? await Task.sleep(for: .milliseconds(1100))
        guard !Task.isCancelled else { return }
        let word = currentWord.word
        recognized = effectiveMode == .spell
            ? word.uppercased().map(String.init).joined(separator: " ")
            : word
        let gained = 12, st = 3
        mic = .success
        answer = .correct
        honey += gained; lastHoney = gained; lastStars = st
        sessHoney += gained; sessCorrect += 1; sessStars += st
    }

    func nextWord() {
        if wordIndex >= Self.words.count - 1 {
            go(.summary)
            return
        }
        wordIndex += 1
        typed = ""; answer = .idle; attempt = 1
        hintLevel = 0; showHintCard = false; mic = .ready; recognized = ""
    }

    func exitSession() { go(.home) }

    // MARK: - Audio

    func playAudio() {
        audioPulse = true
        pulseTask?.cancel()
        pulseTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(900))
            guard !Task.isCancelled else { return }
            self?.audioPulse = false
        }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: currentWord.word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = speedSlow ? 0.32 : AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }

    // MARK: - Overlays / toast / settings

    func openOverlay(_ o: PhoneOverlay) { overlay = o }
    func closeOverlay() { overlay = nil }

    func grantMic() {
        micGranted = true
        overlay = nil
        startSession(mode)
    }

    func denyMic() {
        overlay = nil
        showToast("No problem — you can practise by typing!")
    }

    func showErrorDemo() { overlay = .error(.voice) }

    func showToast(_ message: String) {
        toastMessage = message
        toastTask?.cancel()
        toastTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(2200))
            guard !Task.isCancelled else { return }
            self?.toastMessage = nil
        }
    }
}

//
//  SpellingNormalizer.swift
//  SignLanguageApp
//

import Foundation

struct SpellingNormalizer {

    // MARK: - Letter aliases

    private let letterAliases: [String: Character] = [
        // A
        "a": "A",
        "ay": "A",
        "aye": "A",
        "ey": "A",
        "alpha": "A",

        // B
        "b": "B",
        "be": "B",
        "bee": "B",
        "bi": "B",
        "bravo": "B",

        // C
        "c": "C",
        "see": "C",
        "sea": "C",
        "si": "C",
        "cee": "C",
        "charlie": "C",

        // D
        "d": "D",
        "de": "D",
        "dee": "D",
        "di": "D",
        "delta": "D",

        // E
        "e": "E",
        "ee": "E",
        "echo": "E",

        // F
        "f": "F",
        "ef": "F",
        "eff": "F",
        "foxtrot": "F",

        // G
        "g": "G",
        "gee": "G",
        "ji": "G",
        "golf": "G",

        // H
        "h": "H",
        "aitch": "H",
        "aitche": "H",
        "eitch": "H",
        "hotel": "H",

        // I
        "i": "I",
        "eye": "I",
        "ai": "I",
        "india": "I",

        // J
        "j": "J",
        "jay": "J",
        "jey": "J",
        "juliett": "J",
        "juliet": "J",

        // K
        "k": "K",
        "kay": "K",
        "kei": "K",
        "kilo": "K",

        // L
        "l": "L",
        "el": "L",
        "ell": "L",
        "al": "L",
        "lima": "L",

        // M
        "m": "M",
        "em": "M",
        "emm": "M",
        "mike": "M",

        // N
        "n": "N",
        "en": "N",
        "enn": "N",
        "november": "N",

        // O
        "o": "O",
        "oh": "O",
        "owe": "O",
        "oscar": "O",

        // P
        "p": "P",
        "pee": "P",
        "pi": "P",
        "papa": "P",

        // Q
        "q": "Q",
        "cue": "Q",
        "queue": "Q",
        "kyu": "Q",
        "quebec": "Q",

        // R
        "r": "R",
        "ar": "R",
        "are": "R",
        "aar": "R",
        "romeo": "R",

        // S
        "s": "S",
        "es": "S",
        "ess": "S",
        "sierra": "S",

        // T
        "t": "T",
        "tee": "T",
        "tea": "T",
        "ti": "T",
        "tango": "T",

        // U
        "u": "U",
        "you": "U",
        "yew": "U",
        "yu": "U",
        "uniform": "U",

        // V
        "v": "V",
        "vee": "V",
        "vi": "V",
        "victor": "V",

        // W
        "w": "W",
        "double u": "W",
        "double you": "W",
        "double-u": "W",
        "dubya": "W",
        "whiskey": "W",
        "whisky": "W",

        // X
        "x": "X",
        "ex": "X",
        "eks": "X",
        "x ray": "X",
        "x-ray": "X",
        "xray": "X",

        // Y
        "y": "Y",
        "why": "Y",
        "wai": "Y",
        "yankee": "Y",

        // Z
        "z": "Z",
        "zee": "Z",
        "zed": "Z",
        "zi": "Z",
        "zulu": "Z"
    ]

    // MARK: - Public API

    /// Converts a Speech Framework transcript into detected letters.
    ///
    /// Example:
    /// "see oh see oh en you tee" → ["C", "O", "C", "O", "N", "U", "T"]
    func extractLetters(from transcript: String) -> [Character] {
        let normalizedTranscript = normalize(transcript)
        let words = normalizedTranscript.split(separator: " ").map(String.init)

        var letters: [Character] = []
        var index = 0

        while index < words.count {
            // Try a three-word alias first.
            if index + 2 < words.count {
                let phrase = "\(words[index]) \(words[index + 1]) \(words[index + 2])"

                if let letter = letterAliases[phrase] {
                    letters.append(letter)
                    index += 3
                    continue
                }
            }

            // Try a two-word alias, e.g. "double u" or "x ray".
            if index + 1 < words.count {
                let phrase = "\(words[index]) \(words[index + 1])"

                if let letter = letterAliases[phrase] {
                    letters.append(letter)
                    index += 2
                    continue
                }
            }

            // Try a single-word alias.
            if let letter = letterAliases[words[index]] {
                letters.append(letter)
            }

            index += 1
        }

        return letters
    }

    /// Returns the recognized spelling as one uppercase string.
    ///
    /// Example:
    /// "kay ee el ay pee ay" → "KELAPA"
    func spelling(from transcript: String) -> String {
        String(extractLetters(from: transcript))
    }

    /// Compares the recognized spelling with the target word.
    func evaluate(
        transcript: String,
        target: String
    ) -> SpellingResult {
        var recognized = spelling(from: transcript)

        // Fallback: if phonetic extraction yields nothing, treat the raw transcript
        // as the spoken word itself (e.g. speech recognizer returns "BIG" instead of
        // "bee eye gee").
        if recognized.isEmpty {
            let cleaned = normalize(transcript)
                .replacingOccurrences(of: " ", with: "")
            recognized = cleaned.uppercased()
        }

        let expected = normalizeTarget(target)

        let comparisons = zipWithPadding(
            recognized.map(String.init),
            expected.map(String.init)
        ).enumerated().map { index, pair in
            LetterComparison(
                index: index,
                expected: pair.expected,
                recognized: pair.recognized,
                isCorrect: pair.expected == pair.recognized
            )
        }

        let correctCount = comparisons.filter(\.isCorrect).count
        let totalCount = max(expected.count, recognized.count)

        let accuracy: Double = totalCount == 0
            ? 0
            : Double(correctCount) / Double(totalCount)

        return SpellingResult(
            transcript: transcript,
            recognized: recognized,
            expected: expected,
            isCorrect: recognized == expected,
            accuracy: accuracy,
            comparisons: comparisons
        )
    }

    // MARK: - Normalization

    private func normalize(_ text: String) -> String {
        text
            .folding(
                options: [.caseInsensitive, .diacriticInsensitive],
                locale: Locale(identifier: "en_US")
            )
            .lowercased()
            .replacingOccurrences(
                of: #"[^a-z\s-]"#,
                with: " ",
                options: .regularExpression
            )
            .replacingOccurrences(
                of: #"\s+"#,
                with: " ",
                options: .regularExpression
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func normalizeTarget(_ target: String) -> String {
        target
            .folding(
                options: [.caseInsensitive, .diacriticInsensitive],
                locale: .current
            )
            .uppercased()
            .filter(\.isLetter)
    }

    private func zipWithPadding(
        _ recognized: [String],
        _ expected: [String]
    ) -> [(recognized: String?, expected: String?)] {
        let count = max(recognized.count, expected.count)

        return (0..<count).map { index in
            (
                recognized: index < recognized.count ? recognized[index] : nil,
                expected: index < expected.count ? expected[index] : nil
            )
        }
    }
}

// MARK: - Result models

struct SpellingResult {
    let transcript: String
    let recognized: String
    let expected: String
    let isCorrect: Bool
    let accuracy: Double
    let comparisons: [LetterComparison]
}

struct LetterComparison: Identifiable {
    let id = UUID()
    let index: Int
    let expected: String?
    let recognized: String?
    let isCorrect: Bool
}

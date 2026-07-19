//
//  SpellingPracticeView.swift
//  SignLanguageApp
//

import SwiftUI

struct SpellingPracticeExampleView: View {
    @State private var viewModel = SpellingPracticeExampleViewModel()

    var body: some View {
        VStack(spacing: 32) {
            // Difficulty picker
            Picker("Difficulty", selection: $viewModel.difficulty) {
                ForEach(Difficulty.allCases, id: \.self) { level in
                    Text(level.rawValue).tag(level)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 24)
            .disabled(viewModel.state == .recording)

            Spacer()

            Text("Spell This Word")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(viewModel.targetWord)
                .font(.system(size: 72, weight: .bold, design: .rounded))

            Spacer()

            if viewModel.state == .recording, !viewModel.recognizedText.isEmpty {
                Text("\"\(viewModel.recognizedText)\"")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            resultLabel

            if let result = viewModel.result {
                resultPanel(result)
            }

            actionButton
                .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.requestPermissions()
        }
    }

    @ViewBuilder
    private var resultLabel: some View {
        switch viewModel.state {
        case .correct:
            Text("Correct!")
                .font(.title.bold())
                .foregroundStyle(.green)
        case .tryAgain:
            Text("Try Again")
                .font(.title.bold())
                .foregroundStyle(.red)
        default:
            Color.clear.frame(height: 36)
        }
    }

    @ViewBuilder
    private func resultPanel(_ result: SpellingResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(result.isCorrect ? "✓ Correct" : "✗ Try Again")
                .font(.callout.bold())
                .foregroundStyle(result.isCorrect ? .green : .red)
                .frame(maxWidth: .infinity)

            // Per-letter comparison
            HStack(spacing: 6) {
                ForEach(result.comparisons) { comp in
                    VStack(spacing: 2) {
                        if let expected = comp.expected {
                            Text(expected)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(comp.isCorrect ? .green : .red)
                                .frame(width: 28, height: 32)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(comp.isCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                                )
                        } else {
                            Text("-")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondary)
                                .frame(width: 28, height: 32)
                        }

                        if let recognized = comp.recognized {
                            Text(recognized)
                                .font(.caption2)
                                .foregroundStyle(comp.isCorrect ? .green : .orange)
                        }
                    }
                }
            }

            // Accuracy bar
            VStack(spacing: 4) {
                HStack {
                    Text("Accuracy")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(Int(result.accuracy * 100))%")
                        .foregroundStyle(result.accuracy >= 0.8 ? .green : .orange)
                }
                .font(.caption2)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.tertiary)
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(result.accuracy >= 0.8 ? Color.green : Color.orange)
                            .frame(width: geo.size.width * result.accuracy, height: 8)
                    }
                }
                .frame(height: 8)
            }

            Divider()

            HStack {
                Text("Heard")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(result.transcript.isEmpty ? "(nothing)" : "\"\(result.transcript)\"")
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.trailing)
            }
            .font(.caption2)

            HStack {
                Text("Normalized")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(result.recognized.isEmpty ? "(empty)" : result.recognized)
                    .foregroundStyle(.primary)
            }
            .font(.caption2)

            HStack {
                Text("Expected")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(result.expected)
                    .foregroundStyle(.primary)
            }
            .font(.caption2)
        }
        .padding(14)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 24)
        .monospacedDigit()
    }

    @ViewBuilder
    private var actionButton: some View {
        switch viewModel.state {
        case .idle:
            Button("Start Spelling") {
                viewModel.startRecording()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        case .recording:
            Button("Stop & Check") {
                viewModel.stopAndEvaluate()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .controlSize(.large)
        case .correct, .tryAgain:
            Button("Next Word") {
                viewModel.reset()
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }
}

#Preview {
    SpellingPracticeExampleView()
}

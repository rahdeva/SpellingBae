//
//  PhonePracticeFlow.swift
//  SpellingBae
//
//  Practice mode picker, the practice session, and the session summary.
//

import SwiftUI

// MARK: - Practice select

struct PracticeSelectView: View {
    @Bindable var model: PhoneViewModel

    private struct Mode: Identifiable {
        let id: PracticeMode
        let name, emoji, len, desc: String
        let tint, border: Color
    }

    private let modes: [Mode] = [
        .init(id: .listen, name: "Listen & Spell", emoji: "🎧", len: "~4 min",
              desc: "Hear the word, then type or arrange the letters.",
              tint: Color(hex: 0xFFF1D6), border: Color(hex: 0xF2D89A)),
        .init(id: .spell, name: "Spell Aloud", emoji: "🗣️", len: "~3 min",
              desc: "Say each letter out loud, one by one.",
              tint: Color(hex: 0xEAF6FF), border: Color(hex: 0xC6E4F5)),
        .init(id: .say, name: "Say the Word", emoji: "🎤", len: "~3 min",
              desc: "Listen, then say the whole word clearly.",
              tint: Color(hex: 0xFDECE4), border: Color(hex: 0xF5C3B4)),
        .init(id: .mixed, name: "Mixed Practice", emoji: "🌟", len: "~7 min",
              desc: "A fun mix of all the modes — 5 words.",
              tint: Color(hex: 0xE9F7E5), border: Color(hex: 0xBBE3AE)),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    BaeMascotView(mood: .wave, size: 64)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Choose a mode").font(.baloo(24)).foregroundStyle(Bae.ink)
                        Text("How do you want to practise today?")
                            .font(.nunito(14, .semibold)).foregroundStyle(Bae.inkMuted)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.bottom, 6)

                VStack(spacing: 13) {
                    ForEach(modes) { mode in modeCard(mode) }
                }
                .padding(.top, 14)
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

    private func modeCard(_ mode: Mode) -> some View {
        HStack(spacing: 14) {
            Text(mode.emoji).font(.system(size: 28))
                .frame(width: 58, height: 58)
                .background(mode.tint, in: RoundedRectangle(cornerRadius: 18))
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 7) {
                    Text(mode.name).font(.baloo(17)).foregroundStyle(Bae.ink)
                    Text(mode.len)
                        .font(.nunito(11, .heavy)).foregroundStyle(Bae.inkSoft)
                        .padding(.vertical, 2).padding(.horizontal, 7)
                        .background(Color(hex: 0xF6ECD5), in: Capsule())
                }
                Text(mode.desc)
                    .font(.nunito(13, .semibold)).foregroundStyle(Bae.inkMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
            Button { model.startSession(mode.id) } label: {
                Text("Start")
                    .font(.baloo(14, .bold)).foregroundStyle(Bae.ink)
                    .padding(.vertical, 10).padding(.horizontal, 16)
                    .background(Bae.action, in: RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Bae.honeyDeep, radius: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
        .padding(15)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(mode.border, lineWidth: 2))
        .shadow(color: Color(hex: 0xA07828).opacity(0.10), radius: 9, y: 8)
    }
}

// MARK: - Session

struct SessionView: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [Color(hex: 0xFFF7E6), Bae.panel], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                ScrollView {
                    VStack(spacing: 0) {
                        instructionBubble
                        audioSection
                        modeSection
                        if model.showHintCard { hintCard.padding(.top, 18) }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
                .scrollIndicators(.hidden)

                if model.showKeyboard { keyboardFooter }
            }

            if model.answer == .correct { CorrectSheet(model: model) }
            if model.answer == .incorrect { IncorrectSheet(model: model) }
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Button(action: model.exitSession) {
                Text("×").font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(Color(hex: 0x7A5A20))
                    .frame(width: 34, height: 34)
                    .background(Color(hex: 0xF2E4C6), in: Circle())
            }
            .buttonStyle(.plain)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(hex: 0xF2E4C6))
                    Capsule()
                        .fill(LinearGradient(colors: [Bae.honeyLight, Bae.honeyBright], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * model.progressFraction)
                        .animation(.easeOut(duration: 0.4), value: model.progressFraction)
                }
            }
            .frame(height: 12)
            Text("\(model.questionNumber)/\(model.totalWords)")
                .font(.baloo(14)).foregroundStyle(Bae.honey)
        }
        .padding(.horizontal, 18).padding(.top, 6).padding(.bottom, 4)
    }

    private var instructionBubble: some View {
        HStack(spacing: 10) {
            BaeMascotView(mood: .happy, size: 42)
            Text(model.instruction).font(.nunito(14)).foregroundStyle(Bae.ink)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 9).padding(.horizontal, 14)
        .background(
            Color.white,
            in: UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20, bottomLeading: 6, bottomTrailing: 20, topTrailing: 20))
        )
        .overlay(
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20, bottomLeading: 6, bottomTrailing: 20, topTrailing: 20))
                .strokeBorder(Bae.cardBorder, lineWidth: 1)
        )
        .shadow(color: Color(hex: 0xA07828).opacity(0.10), radius: 7, y: 6)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var audioSection: some View {
        VStack(spacing: 0) {
            ZStack {
                if model.audioPulse {
                    Circle().fill(Bae.amber).frame(width: 100, height: 100).pulseRing()
                }
                Button(action: model.playAudio) {
                    Text("🔊").font(.system(size: 44))
                        .frame(width: 100, height: 100)
                        .background(
                            RadialGradient(colors: [Bae.honeyLight, Bae.honeyBright],
                                           center: UnitPoint(x: 0.4, y: 0.35), startRadius: 3, endRadius: 70),
                            in: Circle()
                        )
                        .shadow(color: Bae.honeyDeep.opacity(0.4), radius: 12, y: 10)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 22).padding(.bottom, 8)

            Text("Tap to hear the word").font(.nunito(13)).foregroundStyle(Bae.inkSoft)

            HStack(spacing: 10) {
                pillButton("🔁 Repeat", fill: Bae.pill, border: Bae.pillBorder, text: Bae.honey) { model.playAudio() }
                pillButton("🐌 Slow",
                           fill: model.speedSlow ? Color(hex: 0xFFE7AE) : Bae.pill,
                           border: model.speedSlow ? Color(hex: 0xF2C86A) : Bae.pillBorder,
                           text: model.speedSlow ? Color(hex: 0x8A5600) : Bae.honey) {
                    model.speedSlow.toggle()
                }
            }
            .padding(.top, 12)
        }
    }

    @ViewBuilder
    private var modeSection: some View {
        if model.effectiveMode == .listen {
            HStack(spacing: 8) {
                ForEach(model.slots()) { slot in letterSlot(slot) }
            }
            .padding(.top, 22)
        } else {
            VoiceSection(model: model).padding(.top, 22)
        }
    }

    private func letterSlot(_ slot: PhoneViewModel.Slot) -> some View {
        Text(slot.character)
            .font(.baloo(24)).foregroundStyle(slot.text)
            .frame(width: 40, height: 50)
            .background(slot.fill, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(slot.border, lineWidth: 2.5))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Bae.honeyBright.opacity(slot.isCurrent ? 0.35 : 0), lineWidth: 3))
    }

    private var hintCard: some View {
        VStack(spacing: 0) {
            HStack {
                Text("💡 Hints").font(.baloo(15)).foregroundStyle(Bae.honey)
                Spacer()
                Button(action: model.closeHint) {
                    Text("×").font(.system(size: 16, weight: .heavy)).foregroundStyle(Bae.honey)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 10)
            VStack(spacing: 8) {
                ForEach(model.hints()) { hint in
                    HStack(spacing: 9) {
                        Text(hint.icon).font(.system(size: 15))
                            .frame(width: 30, height: 30)
                            .background(Color(hex: 0xFFE7AE), in: RoundedRectangle(cornerRadius: 9))
                        Text(hint.text).font(.nunito(13.5)).foregroundStyle(Bae.inkMuted)
                        Spacer(minLength: 0)
                    }
                    .opacity(hint.revealed ? 1 : 0.28)
                }
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: 0xFFF6E0), in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color(hex: 0xF2C86A), style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
        )
    }

    private var keyboardFooter: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                footerButton("💡 Hint", fill: Color(hex: 0xFFF6E0), border: Color(hex: 0xF2C86A), text: Bae.honey, action: model.useHint)
                footerButton("⌫ Delete", fill: .white, border: Color(hex: 0xE7D6B4), text: Color(hex: 0x7A5A20), action: model.backspace)
                footerButton("Clear", fill: .white, border: Color(hex: 0xE7D6B4), text: Color(hex: 0x7A5A20), action: model.clearAll)
            }
            .padding(.horizontal, 8).padding(.bottom, 8)

            VStack(spacing: 6) {
                ForEach(Array(model.keyRows.enumerated()), id: \.offset) { _, row in
                    HStack(spacing: 5) {
                        ForEach(Array(row.enumerated()), id: \.offset) { _, letter in
                            Button { model.keyLetter(letter) } label: {
                                Text(String(letter).uppercased())
                                    .font(.baloo(17)).foregroundStyle(Bae.ink)
                                    .frame(maxWidth: 36).frame(height: 44).frame(maxWidth: .infinity)
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 9))
                                    .shadow(color: Bae.keyShadow, radius: 0, y: 2)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, 2)

            Button(action: model.check) {
                Text("Check Answer")
                    .font(.baloo(19))
                    .foregroundStyle(model.canCheck ? Bae.ink : Color(hex: 0xB8A587))
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
                    .background(model.canCheck ? Bae.action : Bae.combEmpty, in: RoundedRectangle(cornerRadius: 18))
                    .shadow(color: model.canCheck ? Bae.honeyDeep : .clear, radius: 0, y: 6)
            }
            .buttonStyle(.plain)
            .padding(.top, 10)
        }
        .padding(8)
        .background(Color(hex: 0xF2E4C6))
    }

    private func pillButton(_ title: String, fill: Color, border: Color, text: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.baloo(13, .bold)).foregroundStyle(text)
                .padding(.vertical, 8).padding(.horizontal, 14)
                .background(fill, in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(border, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }

    private func footerButton(_ title: String, fill: Color, border: Color, text: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.baloo(14, .bold)).foregroundStyle(text)
                .frame(maxWidth: .infinity).padding(.vertical, 11)
                .background(fill, in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(border, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Voice section

private struct VoiceSection: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        VStack(spacing: 14) {
            switch model.mic {
            case .ready:
                Button(action: model.startRecording) {
                    Text("🎤").font(.system(size: 48))
                        .frame(width: 118, height: 118)
                        .background(
                            RadialGradient(colors: [Bae.blueLight, Bae.blueDeep],
                                           center: UnitPoint(x: 0.4, y: 0.35), startRadius: 3, endRadius: 80),
                            in: Circle()
                        )
                        .shadow(color: Bae.blueDeep.opacity(0.4), radius: 12, y: 10)
                }
                .buttonStyle(.plain)
                Text(model.micHint).font(.nunito(14)).foregroundStyle(Bae.inkMuted)
                    .multilineTextAlignment(.center)
                Button(action: model.switchTyping) {
                    Text("⌨ Type instead")
                        .font(.baloo(13, .bold)).foregroundStyle(Bae.honey).underline()
                }
                .buttonStyle(.plain)

            case .recording:
                ZStack {
                    Circle().fill(Bae.micCoral).frame(width: 118, height: 118).pulseRing()
                    Button(action: model.stopRecording) {
                        Text("⏹").font(.system(size: 48))
                            .frame(width: 118, height: 118)
                            .background(
                                RadialGradient(colors: [Bae.micCoralLight, Bae.micCoral],
                                               center: UnitPoint(x: 0.4, y: 0.35), startRadius: 3, endRadius: 80),
                                in: Circle()
                            )
                            .shadow(color: Bae.micCoral.opacity(0.45), radius: 12, y: 10)
                    }
                    .buttonStyle(.plain)
                }
                WaveBars()
                Text("● Listening…").font(.baloo(15)).foregroundStyle(Bae.streak)

            case .processing:
                Text("🐝").font(.system(size: 44))
                    .frame(width: 118, height: 118)
                    .background(Bae.blueTint, in: Circle())
                    .floaty()
                Text("Bae is listening carefully…").font(.baloo(15)).foregroundStyle(Bae.blueDeep)

            case .success:
                VStack(spacing: 4) {
                    Text("BAE HEARD")
                        .font(.nunito(12, .bold)).tracking(0.5).foregroundStyle(Bae.blueSoft)
                    Text(model.recognized)
                        .font(.baloo(30)).tracking(2).foregroundStyle(Bae.blueInk)
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Bae.blueTint, in: RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Bae.blueBorder, lineWidth: 1.5))

            case .failed:
                Text("Bae didn’t catch that").font(.baloo(15)).foregroundStyle(Bae.streak)
                Button(action: model.startRecording) {
                    Text("🎤 Try again").font(.baloo(14, .bold)).foregroundStyle(Bae.honey)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

/// Animated audio waveform shown while "recording".
private struct WaveBars: View {
    @State private var animate = false
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<9, id: \.self) { i in
                Capsule().fill(Bae.micCoral)
                    .frame(width: 5, height: 34)
                    .scaleEffect(y: animate ? 1 : 0.35, anchor: .bottom)
                    .animation(.easeInOut(duration: 0.8).repeatForever().delay(Double(i) * 0.09), value: animate)
            }
        }
        .frame(height: 34)
        .onAppear { animate = true }
    }
}

private struct Floaty: ViewModifier {
    @State private var on = false
    func body(content: Content) -> some View {
        content
            .offset(y: on ? -7 : 0)
            .rotationEffect(.degrees(on ? 4 : -4))
            .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: on)
            .onAppear { on = true }
    }
}

private extension View {
    func floaty() -> some View { modifier(Floaty()) }
}

// MARK: - Feedback sheets

private struct CorrectSheet: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: 0x2B2018).opacity(0.35).ignoresSafeArea()
            VStack(spacing: 0) {
                BaeMascotView(mood: .cheer, size: 120)
                Text(model.correctTitle).font(.baloo(26)).foregroundStyle(Bae.correctInk).padding(.top, 6)
                Text("✓ \(model.currentWord.word)")
                    .font(.baloo(22)).tracking(2).foregroundStyle(Bae.ink)
                    .padding(.vertical, 4).padding(.horizontal, 18)
                    .background(Bae.correctFill, in: RoundedRectangle(cornerRadius: 14))
                    .padding(.top, 8)
                HStack(spacing: 24) {
                    VStack(spacing: 0) {
                        Text(model.starRow).font(.system(size: 26))
                        Text("stars").font(.nunito(12)).foregroundStyle(Bae.inkMuted)
                    }
                    VStack(spacing: 0) {
                        Text("+\(model.lastHoney) 🍯").font(.baloo(24)).foregroundStyle(Bae.honey)
                        Text("honey").font(.nunito(12)).foregroundStyle(Bae.inkMuted)
                    }
                }
                .padding(.top, 16)
                Button(action: model.nextWord) {
                    Text("Continue →").font(.baloo(19)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                        .background(Bae.correctButton, in: RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Bae.correctButtonShadow, radius: 0, y: 6)
                }
                .buttonStyle(.plain)
                .padding(.top, 18)
            }
            .padding(.horizontal, 22).padding(.top, 20).padding(.bottom, 26)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [Color(hex: 0xEEFBEA), .white], startPoint: .top, endPoint: .bottom),
                in: UnevenRoundedRectangle(cornerRadii: .init(topLeading: 30, topTrailing: 30))
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .transition(.move(edge: .bottom))
    }
}

private struct IncorrectSheet: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: 0x2B2018).opacity(0.35).ignoresSafeArea()
            VStack(spacing: 0) {
                BaeMascotView(mood: .oops, size: 96)
                Text(model.incorrectTitle).font(.baloo(24)).foregroundStyle(Bae.streak).padding(.top, 4)
                Text("Look at the letters and try again.")
                    .font(.nunito(14)).foregroundStyle(Bae.inkMuted).padding(.top, 4)
                HStack(spacing: 6) {
                    ForEach(model.slots()) { slot in
                        Text(slot.character)
                            .font(.baloo(20)).foregroundStyle(slot.text)
                            .frame(width: 34, height: 42)
                            .background(slot.fill, in: RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(slot.border, lineWidth: 2))
                    }
                }
                .padding(.top, 14)
                HStack(spacing: 9) {
                    sheetButton("🔊 Listen", fill: Bae.pill, border: Bae.pillBorder, text: Bae.honey) { model.playAudio() }
                    sheetButton("💡 Hint", fill: Color(hex: 0xFFF6E0), border: Color(hex: 0xF2C86A), text: Bae.honey) { model.useHint() }
                }
                .padding(.top, 18)
                Button(action: model.tryAgain) {
                    Text("↻ Try Again").font(.baloo(18)).foregroundStyle(Bae.ink)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(Bae.action, in: RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Bae.honeyDeep, radius: 0, y: 5)
                }
                .buttonStyle(.plain)
                .padding(.top, 9)
            }
            .padding(.horizontal, 22).padding(.top, 20).padding(.bottom, 26)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [Color(hex: 0xFFF4EF), .white], startPoint: .top, endPoint: .bottom),
                in: UnevenRoundedRectangle(cornerRadii: .init(topLeading: 30, topTrailing: 30))
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .transition(.move(edge: .bottom))
    }

    private func sheetButton(_ title: String, fill: Color, border: Color, text: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.baloo(14, .bold)).foregroundStyle(text)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(fill, in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(border, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Summary

struct SummaryView: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                BaeMascotView(mood: .cheer, size: 128)
                Text("Session complete!").font(.baloo(27)).foregroundStyle(Bae.ink).padding(.top, 4)
                Text("You earned more honey. Great buzzing! 🐝")
                    .font(.nunito(15)).foregroundStyle(Bae.inkMuted)
                    .multilineTextAlignment(.center)

                let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
                LazyVGrid(columns: cols, spacing: 12) {
                    statTile("\(model.totalWords)", "Words practised", value: Bae.ink, fill: .white, border: Bae.cardBorder)
                    statTile("\(model.sessCorrect)", "Correct ✓", value: Bae.correctInk, fill: Bae.correctFill, border: Bae.correctBorder)
                    statTile("+\(model.sessHoney) 🍯", "Honey earned", value: Bae.honey, fill: Bae.pill, border: Bae.pillBorder)
                    statTile("\(model.sessStars) ⭐", "Stars collected", value: Bae.honey, fill: Color(hex: 0xFFF6E0), border: Color(hex: 0xF2C86A))
                }
                .padding(.top, 18)

                masteryCard.padding(.top, 12)
                badgeCard.padding(.top, 12)

                HoneyButton(title: "🔁 Review Mistakes") { model.go(.mistakes) }
                    .padding(.top, 16)
                Button { model.go(.home) } label: {
                    Text("🏠 Return Home").font(.baloo(16, .bold)).foregroundStyle(Bae.honey)
                        .frame(maxWidth: .infinity).padding(.vertical, 13)
                        .background(Bae.pill, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Bae.pillBorder, lineWidth: 2))
                }
                .buttonStyle(.plain)
                .padding(.top, 10)
            }
            .padding(.horizontal, 22).padding(.top, 14).padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(
            LinearGradient(colors: [Bae.sidebarTop, Bae.panel], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        )
    }

    private func statTile(_ value: String, _ label: String, value valueColor: Color, fill: Color, border: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value).font(.baloo(26)).foregroundStyle(valueColor)
            Text(label).font(.nunito(12.5)).foregroundStyle(Bae.inkMuted)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(fill, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(border, lineWidth: 1))
    }

    private var masteryCard: some View {
        SoftCard(cornerRadius: 18) {
            VStack(alignment: .leading, spacing: 0) {
                Text("🌟 Newly mastered").font(.nunito(13, .bold)).foregroundStyle(Bae.inkMuted)
                HStack(spacing: 8) {
                    chip("garden", text: Bae.correctInk, fill: Bae.correctFill)
                    chip("flower", text: Bae.correctInk, fill: Bae.correctFill)
                }
                .padding(.top, 8)
                Text("🔁 Needs a little more practice")
                    .font(.nunito(13, .bold)).foregroundStyle(Bae.streak).padding(.top, 12)
                HStack {
                    chip("school", text: Bae.streak, fill: Bae.coralTint)
                    Spacer()
                }
                .padding(.top, 8)
            }
        }
    }

    private func chip(_ text: String, text color: Color, fill: Color) -> some View {
        Text(text).font(.baloo(13, .bold)).foregroundStyle(color)
            .padding(.vertical, 5).padding(.horizontal, 12)
            .background(fill, in: Capsule())
    }

    private var badgeCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("🏅 Perfect Speller badge").font(.baloo(13, .bold)).foregroundStyle(Bae.blueInk)
                Spacer()
                Text("8/10").font(.baloo(13, .bold)).foregroundStyle(Bae.blueInk)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(hex: 0xD3EAF7))
                    Capsule().fill(Bae.blueDeep).frame(width: geo.size.width * 0.8)
                }
            }
            .frame(height: 9)
            .padding(.top, 7)
        }
        .padding(13)
        .background(Bae.blueTint, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Bae.blueBorder, lineWidth: 1))
    }
}
